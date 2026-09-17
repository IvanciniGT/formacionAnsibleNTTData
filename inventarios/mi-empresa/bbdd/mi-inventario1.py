#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json

def main():
    inventory = {
        "oracle": {
            "hosts": ["oracle.prod", "oracle.desa", "oracle.test"]
        }
    }
    print(json.dumps(inventory))

if __name__ == "__main__":
    main()
