import * as assert from 'assert/strict';

import * as cdk from 'aws-cdk-lib';
import { AwsIntegration, PassthroughBehavior, Resource, RestApi, MethodLoggingLevel } from 'aws-cdk-lib/aws-apigateway';
import { AttributeType, BillingMode, Table } from 'aws-cdk-lib/aws-dynamodb';
import { Effect, Policy, PolicyStatement, Role, ServicePrincipal } from 'aws-cdk-lib/aws-iam';
import { Construct, IConstruct } from 'constructs';


export class MyCdkStack extends cdk.Stack {
	private _application: string;
	private _costCenter: string;
	private _environment: string;
	private _table: Table;

	constructor(scope: Construct, id: string, props: cdk.StackProps) {
		super(scope, id, props);

		this._loadContext();
		this._createDynamoTable();
		const apiRole = this._createApiGatewayRole();
		this._createApiGateway(apiRole);

		cdk.Tags.of(this).add('Application', this._application);
		cdk.Tags.of(this).add('CostCenter', this._costCenter);
		cdk.Tags.of(this).add('Environment', this._environment);
	}

	private _createDynamoTable(): void {
		const tableName = this._resourceName('books');
		const table = this._table = new Table(this, 'DynamoDBTable', {
			tableName,
			partitionKey: {
				name: 'Id',
				type: AttributeType.STRING,

			},
			billingMode: BillingMode.PAY_PER_REQUEST,

			/**
			 *  The default removal policy is RETAIN, which means that cdk destroy will not attempt to delete
			 * the new table, and it will remain in your account until manually deleted. By setting the policy to
			 * DESTROY, cdk destroy will delete the table (even if it has data in it)
			 */
			removalPolicy: cdk.RemovalPolicy.DESTROY, // NOT recommended for production code
		});

		this._tagName(table, tableName);
	}

	private _createApiGatewayRole(): Role {
		const policy = new Policy(this, 'APIGatewayPolicy', {
			policyName: this._resourceName('apigateway-policy', true, true),
			statements: [
				new PolicyStatement({
					actions: [
						'dynamodb:PutItem',
						'dynamodb:DeleteItem',
						'dynamodb:GetItem',
						'dynamodb:Scan',
						'dynamodb:Query',
						'dynamodb:UpdateItem',
					],
					effect: Effect.ALLOW,
					resources: [this._table.tableArn],
				}),
			],
		});

		const roleName = this._resourceName('apigateway-role', true, true);
		const role = new Role(this, 'APIGatewayRole', {
			roleName,
			assumedBy: new ServicePrincipal('apigateway.amazonaws.com'),
		});
		role.attachInlinePolicy(policy);
		return role;
	}

	private _createApiGateway(apiRole: Role): void {
		const restApiName = this._resourceName('restapi');
		const api = new RestApi(this, 'Api', {
			restApiName,
			deploy: true, // Auto generate Stage and Deployment
			deployOptions: {
				stageName: this._environment,
				metricsEnabled: false,
				tracingEnabled: true,
				loggingLevel: MethodLoggingLevel.INFO,
				throttlingRateLimit: 100,
				throttlingBurstLimit: 50,
			},
		});
		this._tagName(api, restApiName);
		const books = this._apiBooksResource(api, apiRole);
		this._apiBookIdResource(books, apiRole);
	}

	private _apiBooksResource(api: RestApi, apiRole: Role): Resource {
		const books = api.root.addResource('books');
		this._addBooksMethodPost(books, apiRole);
		this._addBooksMethodGet(books, apiRole);
		return books;
	}

	private _apiBookIdResource(parent: Resource, apiRole: Role): Resource {
		const book = parent.addResource('{bookId}');
		this._addBookIdMethodGet(book, apiRole);
		this._addBookIdMethodDelete(book, apiRole);
		return book;
	}

	private _addBooksMethodPost(resource: Resource, apiRole: Role): void {
		const integration = new AwsIntegration({
			action: 'UpdateItem',
			service: 'dynamodb',
			integrationHttpMethod: 'POST',
			options: {
				credentialsRole: apiRole,
				passthroughBehavior: PassthroughBehavior.WHEN_NO_TEMPLATES,
				requestTemplates: {
					'application/json': `
						{
							"TableName": "${this._table.tableName}",
							"Key": {
								"Id": {
									"S": "$context.requestId"
								}
							},
							"UpdateExpression": "SET Title=:title,Isbn=:isbn,Author=:author,CreatedAt=:createdAt,UpdatedAt=:updatedAt",
							"ExpressionAttributeValues": {
								":title": {
									"S": "$input.path('$.title')"
								},
								":isbn": {
									"S": "$input.path('$.isbn')"
								},
								":author": {
									"S": "$input.path('$.author')"
								},
								":createdAt": {
									"N": "$context.requestTimeEpoch"
								},
								":updatedAt": {
									"N": "$context.requestTimeEpoch"
								}
							},
							"ReturnValues": "ALL_NEW"
						}
					`,
				},
				integrationResponses: [
					{
						statusCode: '200',
						responseTemplates: {
						'application/json': `
							#set($elem = $input.path('$.Attributes'))
							{
								"id": "$elem.Id.S",
								"title": "$elem.Title.S",
								"isbn": "$elem.Isbn.S",
								"author": "$elem.Author.S",
								"createdAt": "$elem.CreatedAt.N",
								"updatedAt": "$elem.UpdatedAt.N"
							}
						`,
						},
					},
				],
			},
		});
		resource.addMethod('POST', integration, {
			methodResponses: [{
				statusCode: '200',
			}]
		});
	}

	private _addBooksMethodGet(resource: Resource, apiRole: Role): void {
		const integration = new AwsIntegration({
			action: 'Scan',
			service: 'dynamodb',
			integrationHttpMethod: 'POST',
			options: {
				credentialsRole: apiRole,
				passthroughBehavior: PassthroughBehavior.WHEN_NO_TEMPLATES,
				requestTemplates: {
					'application/json': `
						{
							"TableName": "${this._table.tableName}"
						}
					`,
				},
				integrationResponses: [
					{
						statusCode: '200',
						responseTemplates: {
						'application/json': `
							#set($inputRoot = $input.path('$'))
							[
							#foreach($elem in $inputRoot.Items) {
								"id": "$elem.Id.S",
								"title": "$elem.Title.S",
								"isbn": "$elem.Isbn.S",
								"author": "$elem.Author.S",
								"createdAt": "$elem.CreatedAt.N",
								"updatedAt": "$elem.UpdatedAt.N"
							}#if($foreach.hasNext),#end
							#end
							]
						`,
						},
					},
				],
			},
		});
		resource.addMethod('GET', integration, {
			methodResponses: [{
				statusCode: '200',
			}]
		});
	}

	private _addBookIdMethodGet(resource: Resource, apiRole: Role): void {
		const integration = new AwsIntegration({
			action: 'GetItem',
			service: 'dynamodb',
			integrationHttpMethod: 'POST',
			options: {
				credentialsRole: apiRole,
				passthroughBehavior: PassthroughBehavior.WHEN_NO_TEMPLATES,
				requestTemplates: {
					'application/json': `
						{
							"TableName": "${this._table.tableName}",
							"Key": {
								"Id": {
									"S": "$input.params('bookId')"
								}
							}
						}
					`,
				},
				integrationResponses: [
					{
						statusCode: '200',
						responseTemplates: {
						'application/json': `
							#set($elem = $input.path('$.Item'))
							#if($elem.Id.S != "")
							{
								"id": "$elem.Id.S",
								"title": "$elem.Title.S",
								"isbn": "$elem.Isbn.S",
								"author": "$elem.Author.S",
								"createdAt": "$elem.CreatedAt.N",
								"updatedAt": "$elem.UpdatedAt.N"
							}
							#else
								#set($context.responseOverride.status = 404)
								{
									"message": "Item not found"
								}
							#end
						`,
						},
					},
				],
			},
		});
		resource.addMethod('GET', integration, {
			methodResponses: [{
				statusCode: '200',
			}]
		});
	}

	private _addBookIdMethodDelete(resource: Resource, apiRole: Role): void {
		const integration = new AwsIntegration({
			action: 'DeleteItem',
			service: 'dynamodb',
			integrationHttpMethod: 'POST',
			options: {
				credentialsRole: apiRole,
				passthroughBehavior: PassthroughBehavior.WHEN_NO_TEMPLATES,
				requestTemplates: {
					'application/json': `
						{
							"TableName": "${this._table.tableName}",
							"Key": {
								"Id": {
									"S": "$input.params('bookId')"
								}
							},
							"ReturnValues": "ALL_OLD"
						}
					`,
				},
				integrationResponses: [
					{
						statusCode: '200',
						responseTemplates: {
						'application/json': `
							#set($elem = $input.path('$.Attributes'))
							#if($elem.Id.S != "")
							{
							"deletedAt": "$context.requestTimeEpoch"
							}
							#else
								#set($context.responseOverride.status = 404)
							{
							"message": "Item not found"
							}
							#end
						`,
						},
					},
				],
			},
		});
		resource.addMethod('DELETE', integration, {
			methodResponses: [{
				statusCode: '200',
			}]
		});
	}

	private _tagName(construct: IConstruct, name: string): void {
		cdk.Tags.of(construct).add('Name', name);
	}

	private _resourceName(name: string, includeAppName = true, isGlobal = false): string {
		const appName = includeAppName ? `${this._application}-` : '';
		const regionName = isGlobal ? `${this.region}-` : '';
		return `${this._costCenter}-${appName}${this._environment}-${regionName}${name}`;
	}

	private _loadContext(): void {
		this._application = this._context('application', 'book-svc');
		this._costCenter = this._context('costcenter', 'fin');
		this._environment = this._context('environment', 'dev');
	}

	private _context(name: string, exampleValue: string): string {
		const value = this.node.tryGetContext(name);
		assert.ok(value, `Context value "${name}" must be specified. For example: npm run synth -- -c ${name}=${exampleValue}`)
		return value;
	}
}
