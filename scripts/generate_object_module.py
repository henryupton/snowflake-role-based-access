#!/usr/bin/env python3

import pathlib

import click
import jinja2


@click.command()
@click.option("--dir")
def main(
        dir: str,
):
    dir_ = pathlib.Path(dir)
    objects = [f for f in dir_.iterdir() if f.is_dir()]

    for object_ in objects:
        with open("./templates/schema_object/main.tf") as m:
            template_main = jinja2.Environment().from_string(m.read())
        with open("./templates/schema_object/variables.tf") as v:
            template_variables = jinja2.Environment().from_string(v.read())

        with (object_ / "main.tf").open(mode="w+") as m:
            m.write(template_main.render(object=object_.stem))
        with (object_ / "variables.tf").open(mode="w+") as v:
            v.write(template_variables.render(object=object_.stem))


if __name__ == "__main__":
    main()
