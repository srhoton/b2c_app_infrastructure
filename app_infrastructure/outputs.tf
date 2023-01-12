output "db_writer_endpoint" {
  value = module.appstack.aws_rds_cluster.b2c_rds_cluster_clone.endpoint
  description = "The writer endpoint for the database"
}
output "db_reader_endpoint" {
  value = module.appstack.aws_rds_cluster.b2c_rds_cluster_clone.reader_endpoint
  description = "The reader endpoint for the database"
}
output "db_cluster_identifier" {
  value = module.appstack.aws_rds_cluster.b2c_rds_cluster_clone.cluster_identifier
  description = "The cluster identifier"
}
output "db_master_username" {
  value = module.appstack.aws_rds_cluster.b2c_rds_cluster_clone.master_username
  description = "The master username of the instance"
}
output "cloudfront_dns_name" {
  value = module.appstack.aws_cloudfront_distribution.b2c_frontend_distribution.domain_name
  description = "The Cloudfront frontend DNS Name"
}
