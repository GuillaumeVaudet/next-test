// app/api/users/phone/[phone]/route.js
import { NextResponse } from 'next/server';
import { getUserByPhone } from '@/services/userService';

/**
 * GET /api/users/phone/[phone] - Récupérer un utilisateur par son téléphone
 */
export async function GET(request, { params }) {
  try {
    const phone = params.phone;

    // Options pour inclure les relations
    const { searchParams } = new URL(request.url);
    const includeRoles = searchParams.get('includeRoles') === 'true';
    const includeOrganizations = searchParams.get('includeOrganizations') === 'true';
    const includeTechnicianTasks = searchParams.get('includeTechnicianTasks') === 'true';
    const includeAlerts = searchParams.get('includeAlerts') === 'true';

    const user = await getUserByPhone(phone, {
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