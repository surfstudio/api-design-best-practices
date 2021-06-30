mkdir -p $1
cat '.api_template' >> "${1}/api.yaml"
cat '..models_template' >> "${1}/models.yaml"