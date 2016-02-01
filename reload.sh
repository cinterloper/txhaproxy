#!/bin/bash
http http://$( dig +short service_router.docker @localhost ):3003/config < example/example.json
