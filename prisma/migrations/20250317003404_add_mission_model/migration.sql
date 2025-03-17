/*
  Warnings:

  - You are about to drop the `address` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `alembic_version` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `alert` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `alert_threshold` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `building` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `building_organization` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `measurement` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `organization` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `role` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `room` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sensor` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sensor_assignment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sensor_type` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `technician_task` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user_organization` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user_role` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `alert` DROP FOREIGN KEY `alert_acknowledged_by_fkey`;

-- DropForeignKey
ALTER TABLE `alert` DROP FOREIGN KEY `alert_alert_threshold_id_fkey`;

-- DropForeignKey
ALTER TABLE `alert` DROP FOREIGN KEY `alert_measurement_id_fkey`;

-- DropForeignKey
ALTER TABLE `alert` DROP FOREIGN KEY `alert_sensor_assignment_id_fkey`;

-- DropForeignKey
ALTER TABLE `alert_threshold` DROP FOREIGN KEY `alert_threshold_building_id_fkey`;

-- DropForeignKey
ALTER TABLE `alert_threshold` DROP FOREIGN KEY `alert_threshold_organization_id_fkey`;

-- DropForeignKey
ALTER TABLE `alert_threshold` DROP FOREIGN KEY `alert_threshold_room_id_fkey`;

-- DropForeignKey
ALTER TABLE `alert_threshold` DROP FOREIGN KEY `alert_threshold_sensor_type_id_fkey`;

-- DropForeignKey
ALTER TABLE `building` DROP FOREIGN KEY `building_ibfk_1`;

-- DropForeignKey
ALTER TABLE `building_organization` DROP FOREIGN KEY `building_organization_building_id_fkey`;

-- DropForeignKey
ALTER TABLE `building_organization` DROP FOREIGN KEY `building_organization_organization_id_fkey`;

-- DropForeignKey
ALTER TABLE `measurement` DROP FOREIGN KEY `measurement_ibfk_1`;

-- DropForeignKey
ALTER TABLE `room` DROP FOREIGN KEY `room_ibfk_1`;

-- DropForeignKey
ALTER TABLE `sensor` DROP FOREIGN KEY `sensor_ibfk_1`;

-- DropForeignKey
ALTER TABLE `sensor` DROP FOREIGN KEY `sensor_sensor_type_id_fkey`;

-- DropForeignKey
ALTER TABLE `sensor_assignment` DROP FOREIGN KEY `sensor_assignment_ibfk_1`;

-- DropForeignKey
ALTER TABLE `sensor_assignment` DROP FOREIGN KEY `sensor_assignment_ibfk_2`;

-- DropForeignKey
ALTER TABLE `technician_task` DROP FOREIGN KEY `technician_task_assigned_to_fkey`;

-- DropForeignKey
ALTER TABLE `technician_task` DROP FOREIGN KEY `technician_task_building_id_fkey`;

-- DropForeignKey
ALTER TABLE `technician_task` DROP FOREIGN KEY `technician_task_room_id_fkey`;

-- DropForeignKey
ALTER TABLE `technician_task` DROP FOREIGN KEY `technician_task_sensor_id_fkey`;

-- DropForeignKey
ALTER TABLE `user_organization` DROP FOREIGN KEY `user_organization_ibfk_1`;

-- DropForeignKey
ALTER TABLE `user_organization` DROP FOREIGN KEY `user_organization_ibfk_2`;

-- DropForeignKey
ALTER TABLE `user_role` DROP FOREIGN KEY `user_role_ibfk_1`;

-- DropForeignKey
ALTER TABLE `user_role` DROP FOREIGN KEY `user_role_ibfk_2`;

-- DropTable
DROP TABLE `address`;

-- DropTable
DROP TABLE `alembic_version`;

-- DropTable
DROP TABLE `alert`;

-- DropTable
DROP TABLE `alert_threshold`;

-- DropTable
DROP TABLE `building`;

-- DropTable
DROP TABLE `building_organization`;

-- DropTable
DROP TABLE `measurement`;

-- DropTable
DROP TABLE `organization`;

-- DropTable
DROP TABLE `role`;

-- DropTable
DROP TABLE `room`;

-- DropTable
DROP TABLE `sensor`;

-- DropTable
DROP TABLE `sensor_assignment`;

-- DropTable
DROP TABLE `sensor_type`;

-- DropTable
DROP TABLE `technician_task`;

-- DropTable
DROP TABLE `user`;

-- DropTable
DROP TABLE `user_organization`;

-- DropTable
DROP TABLE `user_role`;

-- CreateTable
CREATE TABLE `Address` (
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
CREATE TABLE `Alembic_version` (
    `version_num` VARCHAR(32) NOT NULL,

    PRIMARY KEY (`version_num`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Building` (
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
CREATE TABLE `Measurement` (
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
CREATE TABLE `Organization` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `name`(`name`),
    INDEX `ix_organization_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Building_organization` (
    `building_id` INTEGER NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `organization_id`(`organization_id`),
    PRIMARY KEY (`building_id`, `organization_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Role` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `label` VARCHAR(100) NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `label`(`label`),
    INDEX `ix_role_id`(`id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Room` (
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
CREATE TABLE `Sensor_type` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `unit` VARCHAR(191) NULL,
    `min_value` DOUBLE NULL,
    `max_value` DOUBLE NULL,

    UNIQUE INDEX `Sensor_type_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Sensor` (
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
CREATE TABLE `Sensor_assignment` (
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
CREATE TABLE `User` (
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
CREATE TABLE `User_organization` (
    `user_id` INTEGER NOT NULL,
    `organization_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `organization_id`(`organization_id`),
    PRIMARY KEY (`user_id`, `organization_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `User_role` (
    `user_id` INTEGER NOT NULL,
    `role_id` INTEGER NOT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `role_id`(`role_id`),
    PRIMARY KEY (`user_id`, `role_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Technician_task` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'TODO',
    `priority` VARCHAR(191) NOT NULL DEFAULT 'medium',
    `assigned_to` INTEGER NULL,
    `sensor_id` INTEGER NULL,
    `room_id` INTEGER NULL,
    `building_id` INTEGER NULL,
    `scheduled_date` DATETIME(3) NULL,
    `completed_date` DATETIME(3) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,
    `missionId` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Maintenance_mission` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `start_date` DATETIME(3) NOT NULL,
    `end_date` DATETIME(3) NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'PLANNED',
    `priority` VARCHAR(191) NOT NULL DEFAULT 'MEDIUM',
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,
    `responsible_user_id` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Alert_threshold` (
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

    INDEX `Alert_threshold_sensor_type_id_idx`(`sensor_type_id`),
    INDEX `Alert_threshold_organization_id_idx`(`organization_id`),
    INDEX `Alert_threshold_building_id_idx`(`building_id`),
    INDEX `Alert_threshold_room_id_idx`(`room_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Alert` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `message` VARCHAR(255) NOT NULL,
    `alert_threshold_id` INTEGER NOT NULL,
    `sensor_assignment_id` INTEGER NULL,
    `measurement_id` INTEGER NULL,
    `triggered_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `resolved_at` DATETIME(3) NULL,
    `value` DOUBLE NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'active',
    `acknowledged_by` INTEGER NULL,
    `resolution_notes` TEXT NULL,

    INDEX `Alert_alert_threshold_id_idx`(`alert_threshold_id`),
    INDEX `Alert_sensor_assignment_id_idx`(`sensor_assignment_id`),
    INDEX `Alert_measurement_id_idx`(`measurement_id`),
    INDEX `Alert_acknowledged_by_idx`(`acknowledged_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Building` ADD CONSTRAINT `building_ibfk_1` FOREIGN KEY (`address_id`) REFERENCES `Address`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Measurement` ADD CONSTRAINT `measurement_ibfk_1` FOREIGN KEY (`sensor_assignment_id`) REFERENCES `Sensor_assignment`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Building_organization` ADD CONSTRAINT `Building_organization_building_id_fkey` FOREIGN KEY (`building_id`) REFERENCES `Building`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Building_organization` ADD CONSTRAINT `Building_organization_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organization`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Room` ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `Building`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Sensor` ADD CONSTRAINT `sensor_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `Room`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Sensor` ADD CONSTRAINT `Sensor_sensor_type_id_fkey` FOREIGN KEY (`sensor_type_id`) REFERENCES `Sensor_type`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Sensor_assignment` ADD CONSTRAINT `sensor_assignment_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `Room`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Sensor_assignment` ADD CONSTRAINT `sensor_assignment_ibfk_2` FOREIGN KEY (`sensor_id`) REFERENCES `Sensor`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `User_organization` ADD CONSTRAINT `user_organization_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `Organization`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `User_organization` ADD CONSTRAINT `user_organization_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `User_role` ADD CONSTRAINT `user_role_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `Role`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `User_role` ADD CONSTRAINT `user_role_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `Technician_task` ADD CONSTRAINT `Technician_task_assigned_to_fkey` FOREIGN KEY (`assigned_to`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Technician_task` ADD CONSTRAINT `Technician_task_sensor_id_fkey` FOREIGN KEY (`sensor_id`) REFERENCES `Sensor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Technician_task` ADD CONSTRAINT `Technician_task_room_id_fkey` FOREIGN KEY (`room_id`) REFERENCES `Room`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Technician_task` ADD CONSTRAINT `Technician_task_building_id_fkey` FOREIGN KEY (`building_id`) REFERENCES `Building`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Technician_task` ADD CONSTRAINT `Technician_task_missionId_fkey` FOREIGN KEY (`missionId`) REFERENCES `Maintenance_mission`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Maintenance_mission` ADD CONSTRAINT `Maintenance_mission_responsible_user_id_fkey` FOREIGN KEY (`responsible_user_id`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert_threshold` ADD CONSTRAINT `Alert_threshold_sensor_type_id_fkey` FOREIGN KEY (`sensor_type_id`) REFERENCES `Sensor_type`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert_threshold` ADD CONSTRAINT `Alert_threshold_organization_id_fkey` FOREIGN KEY (`organization_id`) REFERENCES `Organization`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert_threshold` ADD CONSTRAINT `Alert_threshold_building_id_fkey` FOREIGN KEY (`building_id`) REFERENCES `Building`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert_threshold` ADD CONSTRAINT `Alert_threshold_room_id_fkey` FOREIGN KEY (`room_id`) REFERENCES `Room`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert` ADD CONSTRAINT `Alert_alert_threshold_id_fkey` FOREIGN KEY (`alert_threshold_id`) REFERENCES `Alert_threshold`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert` ADD CONSTRAINT `Alert_sensor_assignment_id_fkey` FOREIGN KEY (`sensor_assignment_id`) REFERENCES `Sensor_assignment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert` ADD CONSTRAINT `Alert_measurement_id_fkey` FOREIGN KEY (`measurement_id`) REFERENCES `Measurement`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Alert` ADD CONSTRAINT `Alert_acknowledged_by_fkey` FOREIGN KEY (`acknowledged_by`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
