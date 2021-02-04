output "vpc" {
    value = {
        private_cidrs   = module.vpc.private_cidrs
        public_cidrs    = module.vpc.public_cidrs
        id              = module.vpc.vpc_id
    }
}