resource "random_id" "gen" {
  byte_length = "1"
}

resource "azurerm_resource_group" "default" {
  name     = "${var.prefix}-${var.resource_group_name}-${terraform.workspace}-${random_id.gen.hex}-rsg"
  location = "${var.location}"

  tags = "${merge(var.default_tags, map("environment", "${terraform.workspace}"))}"
}

resource "azurerm_app_service_plan" "default" {
  name                = "${var.prefix}-${var.app_service_name}-${terraform.workspace}-${random_id.gen.hex}-plan"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"

  sku {
    tier = "${var.app_service_plan_sku_tier}"
    size = "${var.app_service_plan_sku_size}"
  }

  tags = "${merge(var.default_tags, map("environment", "${terraform.workspace}"))}"
}

resource "azurerm_app_service" "default" {
 
  name                = "${var.prefix}-${var.app_service_name}-${terraform.workspace}-${random_id.gen.hex}-app"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  app_service_plan_id = "${azurerm_app_service_plan.default.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    default_documents = ["hostingstart.html"]
    remote_debugging_enabled = true
    remote_debugging_version = "VS2015"
  }

  app_settings {
    "Meaningoflife" = "41"
  }

  tags = "${merge(var.default_tags, map("environment", "${terraform.workspace}"))}"
}
