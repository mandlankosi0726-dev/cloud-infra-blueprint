mock_provider "aws" {}

run "keeps_database_private_encrypted_and_protected" {
  command = plan
  variables {
    identifier                = "example-postgres"
    final_snapshot_identifier = "example-postgres-final-20261021"
    project                   = "platform"
    environment               = "test"
    engine_version            = "16.4"
    instance_class            = "db.t4g.micro"
    master_username           = "appadmin"
    subnet_ids                = ["subnet-11111111", "subnet-22222222"]
    security_group_ids        = ["sg-11111111"]
  }

  assert {
    condition     = aws_db_instance.this.publicly_accessible == false && aws_db_instance.this.storage_encrypted
    error_message = "RDS must be private and encrypted."
  }
  assert {
    condition     = aws_db_instance.this.deletion_protection && aws_db_instance.this.backup_retention_period == 7 && aws_db_instance.this.manage_master_user_password
    error_message = "RDS must default to deletion protection, retained backups, and a managed master password."
  }
}

run "requires_database_security_groups" {
  command = plan
  variables {
    identifier                = "example-postgres"
    final_snapshot_identifier = "example-postgres-final-20261021"
    project                   = "platform"
    environment               = "test"
    engine_version            = "16.4"
    instance_class            = "db.t4g.micro"
    master_username           = "appadmin"
    subnet_ids                = ["subnet-11111111", "subnet-22222222"]
    security_group_ids        = []
  }
  expect_failures = [var.security_group_ids]
}
