// userService.js
import { prisma } from '@/lib/prisma'; // On importe l'instance Prisma
import bcrypt from 'bcrypt'; // Pour le hachage des mots de passe

/**
 * Récupère tous les utilisateurs
 * @param {Object} options - Options de requête (ex: pagination, filtrage)
 * @returns {Promise<Array>} Liste des utilisateurs
 */
export async function getAllUsers(options = {}) {
  const {
    skip,
    take,
    includeRoles = false,
    includeOrganizations = false,
    includeTechnicianTasks = false,
    includeAlerts = false,
    sortField = 'created_at',
    sortOrder = 'desc'
  } = options;

  const include = {};

  if (includeRoles) {
    include.user_role = {
      include: {
        role: true
      }
    };
  }

  if (includeOrganizations) {
    include.user_organization = {
      include: {
        organization: true
      }
    };
  }

  if (includeTechnicianTasks) {
    include.technician_task = true;
  }

  if (includeAlerts) {
    include.alert = true;
  }

  const orderBy = {};
  orderBy[sortField] = sortOrder;

  return prisma.user.findMany({
    skip,
    take,
    include: Object.keys(include).length > 0 ? include : undefined,
    orderBy
  });
}

/**
 * Récupère un utilisateur par son ID
 * @param {number} id - ID de l'utilisateur
 * @param {Object} options - Options de requête
 * @returns {Promise<Object|null>} Utilisateur trouvé ou null
 */
export async function getUserById(id, options = {}) {
  const {
    includeRoles = false,
    includeOrganizations = false,
    includeTechnicianTasks = false,
    includeAlerts = false
  } = options;

  const include = {};

  if (includeRoles) {
    include.user_role = {
      include: {
        role: true
      }
    };
  }

  if (includeOrganizations) {
    include.user_organization = {
      include: {
        organization: true
      }
    };
  }

  if (includeTechnicianTasks) {
    include.technician_task = true;
  }

  if (includeAlerts) {
    include.alert = true;
  }

  return prisma.user.findUnique({
    where: { id: parseInt(id) },
    include: Object.keys(include).length > 0 ? include : undefined
  });
}

/**
 * Récupère un utilisateur par son email
 * @param {string} email - Adresse email de l'utilisateur
 * @param {Object} options - Options de requête
 * @returns {Promise<Object|null>} Utilisateur trouvé ou null
 */
export async function getUserByEmail(email, options = {}) {
  const {
    includeRoles = false,
    includeOrganizations = false,
    includeTechnicianTasks = false,
    includeAlerts = false
  } = options;

  const include = {};

  if (includeRoles) {
    include.user_role = {
      include: {
        role: true
      }
    };
  }

  if (includeOrganizations) {
    include.user_organization = {
      include: {
        organization: true
      }
    };
  }

  if (includeTechnicianTasks) {
    include.technician_task = true;
  }

  if (includeAlerts) {
    include.alert = true;
  }

  return prisma.user.findUnique({
    where: { email },
    include: Object.keys(include).length > 0 ? include : undefined
  });
}

/**
 * Récupère un utilisateur par son numéro de téléphone
 * @param {string} phone - Numéro de téléphone de l'utilisateur
 * @param {Object} options - Options de requête
 * @returns {Promise<Object|null>} Utilisateur trouvé ou null
 */
export async function getUserByPhone(phone, options = {}) {
  const {
    includeRoles = false,
    includeOrganizations = false,
    includeTechnicianTasks = false,
    includeAlerts = false
  } = options;

  const include = {};

  if (includeRoles) {
    include.user_role = {
      include: {
        role: true
      }
    };
  }

  if (includeOrganizations) {
    include.user_organization = {
      include: {
        organization: true
      }
    };
  }

  if (includeTechnicianTasks) {
    include.technician_task = true;
  }

  if (includeAlerts) {
    include.alert = true;
  }

  return prisma.user.findUnique({
    where: { phone },
    include: Object.keys(include).length > 0 ? include : undefined
  });
}

/**
 * Crée un nouvel utilisateur avec ses relations
 * @param {Object} userData - Données de l'utilisateur
 * @param {Array} roles - IDs des rôles à attribuer
 * @param {Array} organizations - IDs des organisations à associer
 * @returns {Promise<Object>} L'utilisateur créé
 */
export async function createUser(userData, roles = [], organizations = []) {
  if (userData.password) {
    userData.password = await bcrypt.hash(userData.password, 10);
  }

  return prisma.$transaction(async (tx) => {
    const user = await tx.user.create({
      data: {
        first_name: userData.first_name,
        last_name: userData.last_name,
        email: userData.email,
        password: userData.password,
        phone: userData.phone,
      }
    });

    if (roles.length > 0) {
      const roleData = roles.map(roleId => ({
        user_id: user.id,
        role_id: parseInt(roleId)
      }));

      await tx.user_role.createMany({
        data: roleData
      });
    }

    if (organizations.length > 0) {
      const orgData = organizations.map(orgId => ({
        user_id: user.id,
        organization_id: parseInt(orgId)
      }));

      await tx.user_organization.createMany({
        data: orgData
      });
    }

    return tx.user.findUnique({
      where: { id: user.id },
      include: {
        user_role: { include: { role: true } },
        user_organization: { include: { organization: true } }
      }
    });
  });
}

/**
 * Met à jour un utilisateur et ses relations
 */
export async function updateUser(id, userData, { roles, organizations } = {}) {
  const userId = parseInt(id);

  return prisma.$transaction(async (tx) => {
    // Mise à jour des informations utilisateur
    const updatedUser = await tx.user.update({
      where: { id: userId },
      data: {
        first_name: userData.first_name,
        last_name: userData.lastName,
        email: userData.email,
        phone: userData.phone,
        is_active: userData.isActive
        // Note: éviter de mettre à jour le mot de passe ici,
        // créer une fonction séparée pour ça
      }
    });

    // Mise à jour des rôles si fournis
    if (roles) {
      // Supprimer les rôles existants
      await tx.user_role.deleteMany({
        where: { user_id: userId }
      });

      // Ajouter les nouveaux rôles
      if (roles.length > 0) {
        await tx.user_role.createMany({
          data: roles.map(roleId => ({
            user_id: userId,
            role_id: parseInt(roleId)
          }))
        });
      }
    }

    // Mise à jour des organisations si fournies
    if (organizations) {
      // Logique similaire pour les organisations
      await tx.user_organization.deleteMany({
        where: { user_id: userId }
      });

      if (organizations.length > 0) {
        await tx.user_organization.createMany({
          data: organizations.map(orgId => ({
            user_id: userId,
            organization_id: parseInt(orgId)
          }))
        });
      }
    }

    // Récupérer l'utilisateur mis à jour avec ses relations
    return tx.user.findUnique({
      where: { id: userId },
      include: {
        user_role: { include: { role: true } },
        user_organization: { include: { organization: true } }
      }
    });
  });
}

/**
 * Supprime un utilisateur
 * @param {number} id - ID de l'utilisateur
 * @returns {Promise<Object>} Utilisateur supprimé
 */
export async function deleteUser(id) {

  await prisma.user_role.deleteMany({
    where: { user_id: parseInt(id) }
  });

  await prisma.user_organization.deleteMany({
    where: { user_id: parseInt(id) }
  });


  return prisma.user.delete({
    where: { id: parseInt(id) }
  });
}

/**
 * Attribue un rôle à un utilisateur
 * @param {number} userId - ID de l'utilisateur
 * @param {number} roleId - ID du rôle
 * @returns {Promise<Object>} Relation user_role créée
 */
export async function assignRoleToUser(userId, roleId) {
  return prisma.user_role.create({
    data: {
      user_id: parseInt(userId),
      role_id: parseInt(roleId)
    },
    include: {
      user: true,
      role: true
    }
  });
}

/**
 * Retire un rôle à un utilisateur
 * @param {number} userId - ID de l'utilisateur
 * @param {number} roleId - ID du rôle
 * @returns {Promise<Object>} Relation user_role supprimée
 */
export async function removeRoleFromUser(userId, roleId) {
  return prisma.user_role.delete({
    where: {
      user_id_role_id: {
        user_id: parseInt(userId),
        role_id: parseInt(roleId)
      }
    }
  });
}

/**
 * Ajoute un utilisateur à une organisation
 * @param {number} userId - ID de l'utilisateur
 * @param {number} organizationId - ID de l'organisation
 * @returns {Promise<Object>} Relation user_organization créée
 */
export async function addUserToOrganization(userId, organizationId) {
  return prisma.user_organization.create({
    data: {
      user_id: parseInt(userId),
      organization_id: parseInt(organizationId)
    },
    include: {
      user: true,
      organization: true
    }
  });
}

/**
 * Retire un utilisateur d'une organisation
 * @param {number} userId - ID de l'utilisateur
 * @param {number} organizationId - ID de l'organisation
 * @returns {Promise<Object>} Relation user_organization supprimée
 */
export async function removeUserFromOrganization(userId, organizationId) {
  return prisma.user_organization.delete({
    where: {
      user_id_organization_id: {
        user_id: parseInt(userId),
        organization_id: parseInt(organizationId)
      }
    }
  });
}

/**
 * Vérifie si les informations de login sont valides
 * @param {string} email - Email de l'utilisateur
 * @param {string} password - Mot de passe en clair
 * @returns {Promise<Object|null>} Utilisateur si authentification réussie, null sinon
 */
export async function verifyUserCredentials(email, password) {
  const user = await prisma.user.findUnique({
    where: { email }
  });

  if (!user) return null;

  const passwordValid = await bcrypt.compare(password, user.password);
  if (!passwordValid) return null;

  const { password: _, ...userWithoutPassword } = user;
  return userWithoutPassword;
}

/**
 * Récupère les rôles d'un utilisateur
 * @param {number} userId - ID de l'utilisateur
 * @returns {Promise<Array>} Liste des rôles
 */
export async function getUserRoles(userId) {
  const userWithRoles = await prisma.user.findUnique({
    where: { id: parseInt(userId) },
    include: {
      user_role: {
        include: {
          role: true
        }
      }
    }
  });

  return userWithRoles?.user_role?.map(ur => ur.role) || [];
}

/**
 * Récupère les organisations d'un utilisateur
 * @param {number} userId - ID de l'utilisateur
 * @returns {Promise<Array>} Liste des organisations
 */
export async function getUserOrganizations(userId) {
  const userWithOrgs = await prisma.user.findUnique({
    where: { id: parseInt(userId) },
    include: {
      user_organization: {
        include: {
          organization: true
        }
      }
    }
  });

  return userWithOrgs?.user_organization?.map(uo => uo.organization) || [];
}

/**
 * Recherche d'utilisateurs par critères
 * @param {Object} criteria - Critères de recherche
 * @returns {Promise<Array>} Liste des utilisateurs correspondants
 */
export async function searchUsers(criteria) {
  const {
    first_name,
    last_name,
    email,
    phone,
    roleId,
    organizationId,
    skip,
    take
  } = criteria;

  const where = {};

  if (first_name) {
    where.first_name = { contains: first_name };
  }

  if (lastName) {
    where.last_name = { contains: lastName };
  }

  if (email) {
    where.email = { contains: email };
  }

  if (phone) {
    where.phone = { contains: phone };
  }

  // Pour les relations, on utilise des sous-requêtes
  if (roleId) {
    where.user_role = {
      some: {
        role_id: parseInt(roleId)
      }
    };
  }

  if (organizationId) {
    where.user_organization = {
      some: {
        organization_id: parseInt(organizationId)
      }
    };
  }

  return prisma.user.findMany({
    where,
    skip,
    take,
    include: {
      user_role: {
        include: { role: true }
      },
      user_organization: {
        include: { organization: true }
      }
    }
  });
}

/**
 * Vérifie si le mot de passe correspond à celui de l'utilisateur
 * @param {number} userId - ID de l'utilisateur
 * @param {string} password - Mot de passe à vérifier
 * @returns {Promise<boolean>} True si le mot de passe est correct
 */
export async function verifyUserPassword(userId, password) {
  const user = await prisma.user.findUnique({
    where: { id: parseInt(userId) },
    select: { password: true }
  });

  if (!user || !user.password) {
    return false;
  }

  return bcrypt.compare(password, user.password);
}