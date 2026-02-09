return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  root_markers = { '.git' },
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Lazy-load schemastore schemas + custom Kubernetes schemas
    local schemas = require('schemastore').yaml.schemas()
    -- Add Kubernetes schema for common k8s file patterns
    schemas['kubernetes'] = {
      '*-definition.yml',
      '*-pod.yml',
      '*-service.yml',
      '*-deployment.yml',
      '*-deployment.yaml',
      '*-definition.yaml',
      '*-pod.yaml',
      '*-service.yaml',
      '*.k8s.yml',
      '*.k8s.yaml',
      '**/k8s/**/*.yml',
      '**/k8s/**/*.yaml',
      '**/kubernetes/**/*.yml',
      '**/kubernetes/**/*.yaml',
    }
    client.config.settings.yaml.schemas = vim.tbl_deep_extend('force', client.config.settings.yaml.schemas or {}, schemas)
    client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = { enable = true },
      validate = true,
      schemaStore = {
        enable = false,
        url = '',
      },
    },
  },
}
