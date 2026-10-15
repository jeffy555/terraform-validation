owner                             = "platform-team"
cost_center                       = "spiritops-test"
worker_count_request_30b5080f2088 = 1
administrator_password_wo         = "@generated(\"password\")"

private_endpoints = {
  "blob" : {
    "name" : "pe-apptest-blob",
    "subresource_names" : [
      "blob"
    ],
    "dns_zone_key" : "blob"
  },
  "queue" : {
    "name" : "pe-apptest-queue",
    "subresource_names" : [
      "queue"
    ],
    "dns_zone_key" : "queue"
  },
  "table" : {
    "name" : "pe-apptest-table",
    "subresource_names" : [
      "table"
    ],
    "dns_zone_key" : "table"
  }
}

private_dns_zones = {
  "blob" : {
    "name" : "privatelink.blob.core.windows.net"
  },
  "queue" : {
    "name" : "privatelink.queue.core.windows.net"
  },
  "table" : {
    "name" : "privatelink.table.core.windows.net"
  }
}

dns_zone_links = {
  "blob" : {
    "name" : "link-apptest-blob",
    "dns_zone_key" : "blob",
    "registration_enabled" : false
  },
  "queue" : {
    "name" : "link-apptest-queue",
    "dns_zone_key" : "queue",
    "registration_enabled" : false
  },
  "table" : {
    "name" : "link-apptest-table",
    "dns_zone_key" : "table",
    "registration_enabled" : false
  }
}

role_assignments = {
  "blob" : {
    "name" : "7c44d5d8-1a14-4e02-9c90-774b409c9f51",
    "role_definition_name" : "Storage Blob Data Owner"
  },
  "queue" : {
    "name" : "7c44d5d8-1a14-4e02-9c90-774b409c9f52",
    "role_definition_name" : "Storage Queue Data Contributor"
  },
  "table" : {
    "name" : "7c44d5d8-1a14-4e02-9c90-774b409c9f53",
    "role_definition_name" : "Storage Account Contributor"
  }
}
