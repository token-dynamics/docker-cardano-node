output "vpc" {
    value = {
        private_cidrs = module.vpc.private_cidrs
        public_cidrs  = module.vpc.public_cidrs
        vpc_id        = module.vpc.vpc_id
    }
}

output "relay" {
    value = {
        instance_id = module.relay.instance_id
        public_ip   = module.relay.public_ip
        eip         = aws_eip.relay.public_ip
    }
}

output "core" {
    value = {
        instance_id = module.core.instance_id
        private_ip  = module.core.private_ip
        public_ip   = module.core.public_ip
    }
}