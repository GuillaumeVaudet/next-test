import { db } from '@/lib/db';

export const userService = {

  async getUsers(page = 1, limit = 10, filter = {}) {
    const skip = (page - 1) * limit;
    const where = { ...filter };

    const [users, total] = await Promise.all([
        db.user.findMany({
          where,
          skip,
          take: limit,
          select : {
            id: true,
            first_name: true,
            last_name: true,
            email: true,
            role: true,
            createdAt: true,
            updatedAt: true,
            user_role: {
              include: {
                role: true
              }
            }
          },
          orderBy: { createdAt: 'desc' }
        }),
        db.user.count({ where })
    ]);

    return { users, total, pages: Math.ceil(total / limit) };
  },

  async getUserById(id) {
    return db.user.findUnique({
      where: { id },
      include: {

      }
    });
  },
}