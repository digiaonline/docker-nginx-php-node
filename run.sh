#!/bin/bash

chown nginx:nginx -R /code
supervisord
