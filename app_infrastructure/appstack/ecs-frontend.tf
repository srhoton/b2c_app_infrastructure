resource "aws_ecs_cluster" "b2c_frontend" {
  name = "b2c-frontend-${var.feature}"
}

resource "aws_ecs_cluster_capacity_providers" "b2c_frontend_provider" {
  cluster_name = aws_ecs_cluster.b2c_frontend.name
  capacity_providers = ["FARGATE"]
}

resource "aws_iam_role" "b2c_frontend_task_execution_role" {
  name = "${aws_ecs_cluster.b2c_frontend.name}-${var.feature}-TaskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "b2c-frontend-task-execution-role-policy-attachment" {
  role       = aws_iam_role.b2c_frontend_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "b2c_frontend_task_definition" {
  family = "b2c_frontend_task_definition-${var.feature}"
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.b2c_frontend_task_execution_role.arn
  task_role_arn = aws_iam_role.b2c_frontend_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  container_definitions = jsonencode([
    {
      name = "b2c_frontend"
      image = "sprhoto/red_machine:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])
}

resource "aws_lb" "b2c_frontend_lb" {
  name = "b2c-frontend-lb-${var.feature}"
  internal = false
  load_balancer_type = "application"
  subnets =  [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id, data.aws_subnet.public_3.id]
  security_groups = [aws_security_group.b2c_frontend_ecs_service.id]

  tags = {
    Name = "b2c_frontend_lb-${var.feature}"
    }
}

resource "aws_lb_target_group" "b2c_frontend_target_group" {
  name = "b2c-frontend-tg-${var.feature}"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = data.aws_vpc.b2c_vpc.id
}

resource "aws_lb_listener" "b2c_frontend_listener" {
  load_balancer_arn = aws_lb.b2c_frontend_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.b2c_frontend_target_group.arn
  }
}

resource "aws_security_group" "b2c_frontend_ecs_service" {
  name = "b2c_frontend_ecs_service-${var.feature}"
  vpc_id = data.aws_vpc.b2c_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "b2c_frontend_ecs_service-$var.feature}"
  }
}

resource "aws_ecs_service" "b2c_frontend_service" {
  name = "b2c-frontend-service-${var.feature}"
  cluster = aws_ecs_cluster.b2c_frontend.id
  task_definition = aws_ecs_task_definition.b2c_frontend_task_definition.arn
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets =  [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id, data.aws_subnet.private_3.id]
    security_groups = [aws_security_group.b2c_frontend_ecs_service.id]
    assign_public_ip = true
  }
      

  load_balancer {
    target_group_arn = aws_lb_target_group.b2c_frontend_target_group.arn
    container_name = "b2c_frontend"
    container_port = 80
  }
}
