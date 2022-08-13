from .base import *

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '%%GUTENBERG_SECRETKEY%%'

ALLOWED_HOSTS = []

STATIC_ROOT = '/var/www/gutenberg/static'

# Admin e-mail addresses to send messages to when errors occur
ADMINS = []

# Database
# https://docs.djangoproject.com/en/2.1/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '%%POSTGRES_DB%%',
        'USER': '%%POSTGRES_USER%%',
        'PASSWORD': '%%POSTGRES_PASSWORD%%',
        'HOST': '%%POSTGRES_SERVER%%',
        'PORT': '%%POSTGRES_PORT%%',
    }
}

# Logging
LOGGING['handlers']['print_file']['filename'] = '/var/log/gutenberg/print.log'
LOGGING['handlers']['django_file']['filename'] = '/var/log/gutenberg/django.log'

# Printing
# Directory to store the printed files in
MEDIA_ROOT = '/prints/'

# Uncomment lines below to enable Open ID Connect auth
# LOGIN_URL = 'oidc_authentication_init'
# OIDC_ADMIN_ROLE = 'ksi'
# OIDC_OP_AUTHORIZATION_ENDPOINT = ''
# OIDC_OP_TOKEN_ENDPOINT = ''
# OIDC_OP_USER_ENDPOINT = 'o'
# OIDC_OP_JWKS_ENDPOINT = ''
# OIDC_OP_LOGOUT_ENDPOINT = ''
# OIDC_RP_CLIENT_ID = ''
# OIDC_RP_CLIENT_SECRET = None
# OIDC_OP_LOGOUT_URL_METHOD = 'gutenberg.auth.oidc_op_logout'
# AUTHENTICATION_BACKENDS = (
#     'django.contrib.auth.backends.ModelBackend',
#     'gutenberg.auth.OIDCAuthenticationBackend',
# )

# Celery
CELERY_BROKER_URL = 'redis://arbitrary_usrname:%%REDIS_PASSWORD%%@%%REDIS_SERVER%%:%%REDIS_PORT%%'

USE_X_FORWARDED_HOST = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

ALLOWED_HOSTS = ['*']
