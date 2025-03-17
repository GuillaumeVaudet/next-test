// app/api/users/route.js
import { NextResponse } from 'next/server';
import {
  getAllUsers,
  createUser,
  getUserByEmail
} from '@/services/userService';

/**
 * GET /api/users - Récupérer tous les utilisateurs
 */
export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);

    const page = parseInt(searchParams.get('page')) || 1;
    const limit = parseInt(searchParams.get('limit')) || 10;
    const skip = (page - 1) * limit;

    const includeRoles = searchParams.get('includeRoles') === 'true';
    const includeOrganizations = searchParams.get('includeOrganizations') === 'true';
    const includeTechnicianTasks = searchParams.get('includeTechnicianTasks') === 'true';
    const includeAlerts = searchParams.get('includeAlerts') === 'true';

    const sortField = searchParams.get('sortField') || 'created_at';
    const sortOrder = searchParams.get('sortOrder') || 'desc';

    const users = await getAllUsers({
      skip,
      take: limit,
      includeRoles,
      includeOrganizations,
      includeTechnicianTasks,
      includeAlerts,
      sortField,
      sortOrder
    });

    return NextResponse.json({ users });
  } catch (error) {
    console.error('Erreur lors de la récupération des utilisateurs:', error);
    return NextResponse.json(
        { error: "Une erreur s'est produite lors de la récupération des utilisateurs" },
        { status: 500 }
    );
  }
}

/**
 * POST /api/users - Créer un nouvel utilisateur
 */
export async function POST(request) {
  try {
    const data = await request.json();
    console.log("Données reçues:", data); // Log des données reçues

    if (!data.email || !data.password || !data.first_name || !data.last_name) {
      return NextResponse.json(
          { error: "Des champs requis sont manquants" },
          { status: 400 }
      );
    }

    // Vérification que les tableaux attendus sont présents
    if (!Array.isArray(data.roles)) {
      console.log("Roles n'est pas un tableau:", data.roles);
      return NextResponse.json(
          { error: "Le champ 'roles' doit être un tableau" },
          { status: 400 }
      );
    }

    if (!Array.isArray(data.organizations)) {
      console.log("Organizations n'est pas un tableau:", data.organizations);
      return NextResponse.json(
          { error: "Le champ 'organizations' doit être un tableau" },
          { status: 400 }
      );
    }

    const existingUser = await getUserByEmail(data.email);
    if (existingUser) {
      return NextResponse.json(
          { error: "Un utilisateur avec cet email existe déjà" },
          { status: 409 }
      );
    }

    // Vérification que les IDs de rôles existent
    // Cette vérification peut être ajoutée si vous avez une fonction pour cela

    try {
      const newUser = await createUser(
          {
            first_name: data.first_name,
            last_name: data.last_name,
            email: data.email,
            password: data.password,
            phone: data.phone,
          },
          data.roles,
          data.organizations
      );

      return NextResponse.json(
          {
            message: "Utilisateur créé avec succès",
            user: newUser
          },
          { status: 201 }
      );
    } catch (createError) {
      console.error("Erreur détaillée lors de la création:", createError);
      return NextResponse.json(
          {
            error: "Erreur lors de la création de l'utilisateur",
            details: createError.message,
            code: createError.code // Pour les erreurs Prisma
          },
          { status: 500 }
      );
    }
  } catch (error) {
    console.error('Erreur complète:', error);
    return NextResponse.json(
        {
          error: "Une erreur s'est produite lors de la création de l'utilisateur",
          details: error.message,
          stack: process.env.NODE_ENV !== 'production' ? error.stack : undefined
        },
        { status: 500 }
    );
  }
}