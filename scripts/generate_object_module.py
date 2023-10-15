#!/usr/bin/env python3

import jinja2

OBJECTS = {
    "database": {
        "type": "account"
    },
    "failover_group": {
        "type": "account"
    },
    "storage_integration": {
        "type": "account",
        "grant_object_type": "integration"
    },
    "replication_group": {
        "type": "account"
    },
    "resource_monitor": {
        "type": "account"
    },
    "user": {
        "type": "account"
    },
    "warehouse": {
        "type": "account"
    },
    "alert": {
        "type": "object"
    },
    "dynamic_table": {
        "type": "object"
    },
    "event_table": {
        "type": "object"
    },
    "external_table": {
        "type": "object"
    },
    "file_format": {
        "type": "object"
    },
    "function": {
        "type": "object"
    },
    "masking_policy": {
        "type": "object",
        "plural": "masking_policies"
    },
    "materialized_view": {
        "type": "object"
    },
    "password_policy": {
        "type": "object",
        "plural": "password_policies"
    },
    "pipe": {
        "type": "object"
    },
    "procedure": {
        "type": "object"
    },
    "row_access_policy": {
        "type": "object",
        "plural": "row_access_policies"
    },
    "secret": {
        "type": "object"
    },
    "sequence": {
        "type": "object"
    },
    "session_policy": {
        "type": "object",
        "plural": "session_policies"
    },
    "stage": {
        "type": "object"
    },
    "stream": {
        "type": "object"
    },
    "table": {
        "type": "object"
    },
    "tag": {
        "type": "object"
    },
    "task": {
        "type": "object"
    },
    "view": {
        "type": "object"
    },
}


def main():
    for k, v in OBJECTS.items():
        values = {
            "object": k,
            "object_plural": v.get("plural", f"{k}s"),
            "object_ws": k.replace("_", " "),
            "object_plural_ws": v.get("plural", f"{k}s").replace("_", " "),
            "grant_object_type": v.get("grant_object_type", k).replace("_", " "),
        }

        for file in ("main.tf", "variables.tf"):
            with open(f"./templates/{v['type']}/{file}") as m:
                template = jinja2.Environment().from_string(m.read())

            with open(f"./modules/role/privileges/{v['type']}/{k}/{file}", "w+") as m:
                m.write(template.render(**values))


if __name__ == "__main__":
    main()
