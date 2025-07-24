provider "aws" {
  region = "eu-north-1"
}

resource "aws_ecr_repository" "repo" {
  name = "board-game-app"
}

resource "aws_ecs_cluster" "cluster" {
  name = "board-game-cluster"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "board-game-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "board-game-app"
    image     = "${aws_ecr_repository.repo.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "service" {
  name            = "board-game-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = ["subnet-024aa601a4696585c"]
    security_groups = ["sg-03865f37baee2fd4b"]
    assign_public_ip = true
  }
}

output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "ecs_task_execution_role_arn" {
  value = data.aws_iam_role.ecs_task_execution_role.arn
}
