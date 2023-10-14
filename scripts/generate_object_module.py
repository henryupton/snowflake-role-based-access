#!/usr/bin/env python3

import pathlib

import click
import inflect
import jinja2


@click.command()
@click.option("--dir")
@click.option("--type")
def main(
        dir: str,
        type: str
):
    object_type_options = ("account", "object")

    if type not in object_type_options:
        raise ValueError(f"Object type {type} not supported.")

    dir_ = pathlib.Path(dir)
    objects = [f for f in dir_.iterdir() if f.is_dir()]

    for object_ in objects:
        values = {
            "object": object_.stem,
            "object_plural": inflect.engine().plural(object_.stem),
            "object_ws": object_.stem.replace("_", " "),
            "object_plural_ws": inflect.engine().plural(object_.stem).replace("_", " "),
        }

        for file in ("main.tf", "variables.tf"):
            with open(f"./templates/{type}/{file}") as m:
                template = jinja2.Environment().from_string(m.read())

            with (object_ / file).open(mode="w+") as m:
                m.write(template.render(**values))


if __name__ == "__main__":
    main()
