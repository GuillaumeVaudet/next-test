// app/api/users/[email]/route.js
import { NextResponse } from 'next/server';
import { getUserByEmail } from '@/services/userService';

/**
 * GET /api/users/email/[email] - Récupérer un utilisateur par son email
 */
export async function GET(request, { params }) {
  try {
    const email = params.email;

    const { searchParams } = new URL(request.url);
    const includeRoles = searchParams.get('includeRoles') === 'true';
    const includeOrganizations = searchParams.get('includeOrganizations') === 'true';
    const includeTechnicianTasks = searchParams.get('includeTechnicianTasks') === 'true';
    const includeAlerts = searchParams.get('includeAlerts') === 'true';

    const user = await getUserByEmail(email, {
      includeRoles,
      includeOrganizations,
      includeTechnicianTasks,
      includeAlerts
    });

    if (!user) {
      return NextResponse.json(
          { error: "Utilisateur non trouvé" },
          { status: 404 }
      );
    }

    return NextResponse.json({ user });
  } catch (error) {
    console.error('Erreur lors de la récupération de l\'utilisateur:', error);
    return NextResponse.json(
        { error: "Une erreur s'est produite lors de la récupération de l'utilisateur" },
        { status: 500 }
    );
  }
}