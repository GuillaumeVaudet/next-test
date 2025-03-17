// app/api/users/[id]/route.js
import { NextResponse } from 'next/server';
import {
  getUserById,
  updateUser,
  deleteUser,
  getUserByEmail,
  getUserByPhone
} from '@/services/userService';

/**
 * GET /api/users/[id] - Récupérer un utilisateur par son ID
 */
export async function GET(request, { params }) {
  try {
    const id = params.id;

    const { searchParams } = new URL(request.url);
    const includeRoles = searchParams.get('includeRoles') === 'true';
    const includeOrganizations = searchParams.get('includeOrganizations') === 'true';
    const includeTechnicianTasks = searchParams.get('includeTechnicianTasks') === 'true';
    const includeAlerts = searchParams.get('includeAlerts') === 'true';

    const user = await getUserById(id, {
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

/**
 * PATCH /api/users/[id] - Mettre à jour un utilisateur
 */
export async function PATCH(request, { params }) {
  try {
    const id = params.id;
    const data = await request.json();

    const existingUser = await getUserById(id);
    if (!existingUser) {
      return NextResponse.json(
          { error: "Utilisateur non trouvé" },
          { status: 404 }
      );
    }

    if (data.email && data.email !== existingUser.email) {
      const userWithSameEmail = await getUserByEmail(data.email);
      if (userWithSameEmail && userWithSameEmail.id !== parseInt(id)) {
        return NextResponse.json(
            { error: "Un autre utilisateur utilise déjà cet email" },
            { status: 409 }
        );
      }
    }

    if (data.phone && data.phone !== existingUser.phone) {
      const userWithSamePhone = await getUserByPhone(data.phone);
      if (userWithSamePhone && userWithSamePhone.id !== parseInt(id)) {
        return NextResponse.json(
            { error: "Un autre utilisateur utilise déjà ce numéro de téléphone" },
            { status: 409 }
        );
      }
    }

    const updatedUser = await updateUser(id, data);

    return NextResponse.json({
      message: "Utilisateur mis à jour avec succès",
      user: updatedUser
    });
  } catch (error) {
    console.error('Erreur lors de la mise à jour de l\'utilisateur:', error);
    return NextResponse.json(
        { error: "Une erreur s'est produite lors de la mise à jour de l'utilisateur" },
        { status: 500 }
    );
  }
}

/**
 * DELETE /api/users/[id] - Supprimer un utilisateur
 */
export async function DELETE(request, { params }) {
  try {
    const id = params.id;

    const existingUser = await getUserById(id);
    if (!existingUser) {
      return NextResponse.json(
          { error: "Utilisateur non trouvé" },
          { status: 404 }
      );
    }

    await deleteUser(id);

    return NextResponse.json({
      message: "Utilisateur supprimé avec succès"
    });
  } catch (error) {
    console.error('Erreur lors de la suppression de l\'utilisateur:', error);
    return NextResponse.json(
        { error: "Une erreur s'est produite lors de la suppression de l'utilisateur" },
        { status: 500 }
    );
  }
}