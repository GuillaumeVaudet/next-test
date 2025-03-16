/*
  Warnings:

  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE `User`;

-- CreateTable
CREATE TABLE `address` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `street` VARCHAR(255) NULL,
    `city` VARCHAR(100) NULL,
    `zip_code` VARCHAR(20) NULL,
    `country` VARCHAR(100) NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    INDEX `ix_address_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `alembic_version` (
    `version_num` VARCHAR(32) NOT NULL,

    PRIMARY KEY (`version_num`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `building` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `address_id` INTEGER NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    INDEX `address_id`(`address_id`),
    INDEX `ix_building_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `measurement` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `sensor_assignment_id` INTEGER NULL,
    `value` FLOAT NOT NULL,
    `unit` VARCHAR(191) NULL,
    `measured_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `ix_measurement_id`(`id`),
    INDEX `sensor_assignment_id`(`sensor_assignment_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `organization` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `name`(`name`),
    INDEX `ix_organization_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `building_organization` (
    `building_id` INTEGER NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `organization_id`(`organization_id`),
    PRIMARY KEY (`building_id`, `organization_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `role` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `label` VARCHAR(100) NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `label`(`label`),
    INDEX `ix_role_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `room` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `is_occupied` BOOLEAN NULL,
    `building_id` INTEGER NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    INDEX `building_id`(`building_id`),
    INDEX `ix_room_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sensor_type` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `unit` VARCHAR(191) NULL,
    `min_value` DOUBLE NULL,
    `max_value` DOUBLE NULL,

    UNIQUE INDEX `sensor_type_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sensor` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NULL,
    `serial_number` VARCHAR(191) NULL,
    `qr_code_path` TEXT NULL,
    `room_id` INTEGER NULL,
    `sensor_type_id` INTEGER NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'status',
    `manufacturer` VARCHAR(191) NULL,
    `model` VARCHAR(191) NULL,
    `protocol` VARCHAR(191) NULL,
    `connection_details` JSON NULL,
    `installation_date` DATETIME(3) NULL,
    `last_calibration` DATETIME(3) NULL,
    `next_calibration_due` DATETIME(3) NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    INDEX `ix_sensor_id`(`id`),
    INDEX `room_id`(`room_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sensor_assignment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `sensor_id` INTEGER NULL,
    `room_id` INTEGER NULL,
    `start_date` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `end_date` DATETIME(0) NULL,

    INDEX `ix_sensor_assignment_id`(`id`),
    INDEX `room_id`(`room_id`),
    INDEX `sensor_id`(`sensor_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `phone` VARCHAR(30) NULL,
    `password` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `ix_user_email`(`email`),
    UNIQUE INDEX `ix_user_phone`(`phone`),
    INDEX `ix_user_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_organization` (
    `user_id` INTEGER NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `organization_id`(`organization_id`),
    PRIMARY KEY (`user_id`, `organization_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_role` (
    `user_id` INTEGER NOT NULL,
    `role_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `role_id`(`role_id`),
    PRIMARY KEY (`user_id`, `role_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `technician_task` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(191) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'pending',
    `priority` VARCHAR(191) NOT NULL DEFAULT 'medium',
    `assigned_to` INTEGER NULL,
    `sensor_id` INTEGER NULL,
    `room_id` INTEGER NULL,
    `building_id` INTEGER NULL,
    `scheduled_date` DATETIME(3) NULL,
    `completed_date` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `alert_threshold` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `sensor_type_id` INTEGER NULL,
    `organization_id` INTEGER NULL,
    `building_id` INTEGER NULL,
    `room_id` INTEGER NULL,
    `min_value` DOUBLE NULL,
    `max_value` DOUBLE NULL,
    `duration_minutes` INTEGER NULL,
    `severity` VARCHAR(191) NOT NULL DEFAULT 'warning',
    `notification_type` VARCHAR(191) NOT NULL DEFAULT 'email',
    `is_active` BOOLEAN NOT NULL DEFAULT true,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    INDEX `alert_threshold_sensor_type_id_idx`(`sensor_type_id`),
    INDEX `alert_threshold_organization_id_idx`(`organization_id`),
    INDEX `alert_threshold_building_id_idx`(`building_id`),
    INDEX `alert_threshold_room_id_idx`(`room_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `alert` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `alert_threshold_id` INTEGER NOT NULL,
    `sensor_assignment_id` INTEGER NULL,
    `measurement_id` INTEGER NULL,
    `triggered_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `resolved_at` DATETIME(3) NULL,
    `value` DOUBLE NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'active',
    `acknowledged_by` INTEGER NULL,
    `resolution_notes` TEXT NULL,

    INDEX `alert_alert_threshold_id_idx`(`alert_threshold_id`),
    INDEX `alert_sensor_assignment_id_idx`(`sensor_assignment_id`),
    INDEX `alert_measurement_id_idx`(`measurement_id`),
    INDEX `alert_acknowledged_by_idx`(`acknowledged_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `building` ADD CONSTRAINT `building_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `address`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `measurement` ADD CONSTRAINT `measurement_ibfk_1` FOREIGN KEY (`sensor_assignment_id`) REFERENCES `sensor_assignment`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `building_organization` ADD CONSTRAINT `building_organization_building_id_fkey` FOREIGN KEY (`building_id`) REFERENCES `building`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `building_organization` ADD CONSTRAINT `building_organization_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `organization`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `room` ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `building`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `sensor` ADD CONSTRAINT `sensor_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `sensor` ADD CONSTRAINT `sensor_sensor_type_id_fkey` FOREIGN KEY (`sensor_type_id`) REFERENCES `sensor_type`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `sensor_assignment` ADD CONSTRAINT `sensor_assignment_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `sensor_assignment` ADD CONSTRAINT `sensor_assignment_ibfk_2` FOREIGN KEY (`sensor_id`) REFERENCES `sensor`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `user_organization` ADD CONSTRAINT `user_organization_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `organization`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `user_organization` ADD CONSTRAINT `user_organization_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `user_role` ADD CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `user_role` ADD CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `technician_task` ADD CONSTRAINT `technician_task_assigned_to_fkey` FOREIGN KEY (`assigned_to`) REFERENCES `user`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `technician_task` ADD CONSTRAINT `technician_task_sensor_id_fkey` FOREIGN KEY (`sensor_id`) REFERENCES `sensor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `technician_task` ADD CONSTRAINT `technician_task_room_id_fkey` FOREIGN KEY (`room_id`) REFERENCES `room`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `technician_task` ADD CONSTRAINT `technician_task_building_id_fkey` FOREIGN KEY (`building_id`) REFERENCES `building`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert_threshold` ADD CONSTRAINT `alert_threshold_sensor_type_id_fkey` FOREIGN KEY (`sensor_type_id`) REFERENCES `sensor_type`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert_threshold` ADD CONSTRAINT `alert_threshold_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `organization`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert_threshold` ADD CONSTRAINT `alert_threshold_building_id_fkey` FOREIGN KEY (`building_id`) REFERENCES `building`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert_threshold` ADD CONSTRAINT `alert_threshold_room_id_fkey` FOREIGN KEY (`room_id`) REFERENCES `room`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert` ADD CONSTRAINT `alert_alert_threshold_id_fkey` FOREIGN KEY (`alert_threshold_id`) REFERENCES `alert_threshold`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert` ADD CONSTRAINT `alert_sensor_assignment_id_fkey` FOREIGN KEY (`sensor_assignment_id`) REFERENCES `sensor_assignment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert` ADD CONSTRAINT `alert_measurement_id_fkey` FOREIGN KEY (`measurement_id`) REFERENCES `measurement`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `alert` ADD CONSTRAINT `alert_acknowledged_by_fkey` FOREIGN KEY (`acknowledged_by`) REFERENCES `user`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
