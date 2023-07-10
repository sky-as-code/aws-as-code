import * as assert from 'assert/strict';

import * as cdk from 'aws-cdk-lib';
import * as codecommit from 'aws-cdk-lib/aws-codecommit';
import { Construct } from 'constructs';


export class CdkStack extends cdk.Stack {
	constructor(scope: Construct, id: string, props?: cdk.StackProps) {
		super(scope, id, props);

		const costCenter = this._context('costcenter', 'fin');
		const repositoryName = this._context('repositoryname', 'book-service');
		const repositoryDesc = this._context('repositorydesc', 'A microservice to manage books');

		const repo = new codecommit.Repository(this, "repository", {
			repositoryName,
			description: repositoryDesc,
		});

		cdk.Tags.of(repo).add('Name', repositoryName);
		cdk.Tags.of(repo).add('CostCenter', costCenter);
	}

	private _context(name: string, exampleValue: string): string {
		const value = this.node.tryGetContext(name);
		assert.ok(value, `Context value "${name}" must be specified. For example: npm run synth -- -c ${name}=${exampleValue}`)
		return value;
	}
}
