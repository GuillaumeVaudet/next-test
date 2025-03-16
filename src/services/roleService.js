import {db} from '@/lib/db';

export const roleService = {

  async getAllRoles() {
    return db.role.findMany({
      orderBy: {
        label: 'asc'
      }
    });
  },

  async getRoleById(id) {
    return db.role.findUnique({
      where: { id }
    });
  },

  async getRoleByLabel(label) {
    return db.role.findUnique({
      where: { label }
    });
  },

  async createRole(label) {
    return db.role.create({
      data: { label }
    });
  },

  async deleteRole(id) {
    return db.role.delete({
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