import click
import generate

@click.group()
def cli():
    pass

@click.command()
@click.option('--resource-group', prompt="Resource group for longlasting resources: ")
@click.option('--location', prompt=True)
@click.option('--tenant-id', prompt="Tenant id(of cluster where cluter is expected): ")
@click.option('--cluster-name', prompt="Prefix for resources(make it short): ")
def setup(resource_group, location, tenant_id, cluster_name):
    click.echo('Running setup...')
    values = {"resource_group": resource_group, "location": location, "tenant_id": tenant_id, "cluster_name": cluster_name}
    generate.generate_template_for_1(values)


@click.command()
def clean():
    click.echo('Cleaning...')

cli.add_command(setup)
cli.add_command(clean)


if __name__ == "__main__":
    cli()    