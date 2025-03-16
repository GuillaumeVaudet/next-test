import { prisma } from '@/lib/prisma';

export const roleService = {

  async getAllRoles() {
    return prisma.role.findMany({
      orderBy: {
        label: 'asc'
      }
    });
  },

  async getRoleById(id) {
    return prisma.role.findUnique({
      where: { id }
    });
  },

  async getRoleByLabel(label) {
    return prisma.role.findUnique({
      where: { label }
    });
  },

  async createRole(label) {
    return prisma.role.create({
      data: { label }
    });
  },

  async deleteRole(id) {
    return prisma.role.delete({
      where: { id }
    });
  },

  async ensureDefaultRoles() {
    const defaultRoles = [
        'god',
        'chibani',
        'sale',
        'tech',
        'admin',
        'coordinator',
        'manager',
        'taskOwner',
        'user',
    ];

    for (const roleLabel of defaultRoles) {
      const existingRole = await this.getRoleByLabel(roleLabel);
      if (!existingRole) {
        await this.createRole(roleLabel);
        console.log(`Created role ${ roleLabel }`);
      }
    }
    console.log('Default roles check completed');
  }
}