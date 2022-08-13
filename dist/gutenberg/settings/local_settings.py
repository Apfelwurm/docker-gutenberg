from .base import *

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '%%GUTENBERG_SECRETKEY%%'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# Database
# https://docs.djangoproject.com/en/2.1/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

# Uncomment lines below to enable Open ID Connect auth
# LOGIN_URL = 'oidc_authentication_init'
# OIDC_ADMIN_ROLE = 'ksi'
# OIDC_OP_AUTHORIZATION_ENDPOINT = 'https://auth.ksi.ii.uj.edu.pl/auth/realms/KSI/protocol/openid-connect/auth'
# OIDC_OP_TOKEN_ENDPOINT = 'https://auth.ksi.ii.uj.edu.pl/auth/realms/KSI/protocol/openid-connect/token'
# OIDC_OP_USER_ENDPOINT = 'https://auth.ksi.ii.uj.edu.pl/auth/realms/KSI/protocol/openid-connect/userinfo'
# OIDC_OP_JWKS_ENDPOINT = 'https://auth.ksi.ii.uj.edu.pl/auth/realms/KSI/protocol/openid-connect/certs'
# OIDC_OP_LOGOUT_ENDPOINT = 'https://auth.ksi.ii.uj.edu.pl/auth/realms/KSI/protocol/openid-connect/logout'
# OIDC_RP_CLIENT_ID = 'YOUR_CLIENT_ID'
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
