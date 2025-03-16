// userService.js
import { prisma } from '@/lib/db'; // On importe l'instance Prisma
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

  // Construction de l'objet d'inclusion pour les relations
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

  // Construction de l'objet de tri
  const orderBy = {};
  orderBy[sortField] = sortOrder;

  // Exécution de la requête avec Prisma
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

  // Construction de l'objet d'inclusion pour les relations
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

  // Construction de l'objet d'inclusion pour les relations
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

  // Construction de l'objet d'inclusion pour les relations
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
 * Crée un nouvel utilisateur
 * @param {Object} userData - Données de l'utilisateur
 * @returns {Promise<Object>} Utilisateur créé
 */
export async function createUser(userData) {
  // Extraction des données pour les relations
  const { roles, organizations, ...userInfo } = userData;

  // On vérifie si un mot de passe est fourni
  if (userInfo.password) {
    // Hachage du mot de passe avant stockage
    const salt = await bcrypt.genSalt(10);
    userInfo.password = await bcrypt.hash(userInfo.password, salt);
  }

  // Préparation des données pour les relations
  const userRoles = Array.isArray(roles) ? roles.map(roleId => ({
    role: { connect: { id: parseInt(roleId) } }
  })) : [];

  const userOrgs = Array.isArray(organizations) ? organizations.map(orgId => ({
    organization: { connect: { id: parseInt(orgId) } }
  })) : [];

  // Création de l'utilisateur avec ses relations
  return prisma.user.create({
    data: {
      ...userInfo,
      user_role: {
        create: userRoles
      },
      user_organization: {
        create: userOrgs
      }
    },
    include: {
      user_role: {
        include: {
          role: true
        }
      },
      user_organization: {
        include: {
          organization: true
        }
      }
    }
  });
}

/**
 * Met à jour les informations d'un utilisateur
 * @param {number} id - ID de l'utilisateur
 * @param {Object} userData - Nouvelles données
 * @returns {Promise<Object>} Utilisateur mis à jour
 */
export async function updateUser(id, userData) {
  const { roles, organizations, ...userInfo } = userData;

  // Si le mot de passe est présent dans les données, on le hache
  if (userInfo.password) {
    const salt = await bcrypt.genSalt(10);
    userInfo.password = await bcrypt.hash(userInfo.password, salt);
  }

  // Mise à jour de l'utilisateur
  return prisma.user.update({
    where: { id: parseInt(id) },
    data: userInfo
  });
}

/**
 * Supprime un utilisateur
 * @param {number} id - ID de l'utilisateur
 * @returns {Promise<Object>} Utilisateur supprimé
 */
export async function deleteUser(id) {
  // En raison des relations, nous devons d'abord supprimer les entrées dans les tables de jointure

  // Suppression des rôles associés
  await prisma.user_role.deleteMany({
    where: { user_id: parseInt(id) }
  });

  // Suppression des organisations associées
  await prisma.user_organization.deleteMany({
    where: { user_id: parseInt(id) }
  });

  // Si l'utilisateur a des tâches de technicien ou des alertes associées,
  // il faudrait les gérer aussi selon la logique métier

  // Suppression de l'utilisateur
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

  // On renvoie l'utilisateur sans son mot de passe pour la sécurité
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
    firstName,
    lastName,
    email,
    phone,
    roleId,
    organizationId,
    skip,
    take
  } = criteria;

  // Construction des conditions de recherche
  const where = {};

  if (firstName) {
    where.first_name = { contains: firstName };
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