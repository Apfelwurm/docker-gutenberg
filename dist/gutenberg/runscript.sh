#!/bin/bash -i
python3 /app/gutenberg/manage.py migrate
python3 /app/gutenberg/manage.py runserver 0.0.0.0:11111
