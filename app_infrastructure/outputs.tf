output "db_writer_endpoint" {
  value = module.appstack.db_writer_endpoint
  description = "The writer endpoint for the database"
}
output "db_reader_endpoint" {
  value = module.appstack.db_reader_endpoint
  description = "The reader endpoint for the database"
}
output "db_cluster_identifier" {
  value = module.appstack.db_cluster_identifier
  description = "The cluster identifier"
}
output "db_master_username" {
  value = module.appstack.db_master_username
  description = "The master username of the instance"
}
output "cloudfront_dns_name" {
  value = module.appstack.cloudfront_dns_name
  description = "The Cloudfront frontend DNS Name"
}
