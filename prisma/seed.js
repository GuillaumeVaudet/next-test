const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding...');

  const roles = [
    { label: 'god',
    },
    { label: 'chibani',
    },
    { label: 'sale',
    },
    { label: 'tech',
    },
    { label: 'admin',
    },
    { label: 'coordinator',
    },
    { label: 'manager',
    },
    { label: 'taskOwner',
    },
    { label: 'user',
    },
  ];

  for (const role of roles) {
    const existingRole = await prisma.role.findFirst({
      where: { label: role.label }
    });

    if (!existingRole) {
      await prisma.role.create({
        data: role
      });
      console.log(`Created role ${ role.label }`);
    } else {
      console.log(`Role ${ role.label } already exists`);
    }
  }
}

main()
    .catch((e) => {
  console.error(e);
  process.exit(1);
  })
    .finally(async () => {
  await prisma.$disconnect();
})