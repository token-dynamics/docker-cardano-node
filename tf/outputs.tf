output "vpc" {
    value = {
        private_cidrs   = module.vpc.private_cidrs
        public_cidrs    = module.vpc.public_cidrs
        id              = module.vpc.vpc_id
    }
}

output "relay" {
    value = {
        instance_id = module.relay.instance_id
        public_ip   = module.relay.public_ip
        eip         = module.relay.eip
    }
}

output "core" {
    value = {
        instance_id = module.core.instance_id
        private_ip  = module.core.private_ip
        public_ip   = module.core.public_ip
    }
}