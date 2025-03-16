// src/middleware.js
import { NextResponse } from 'next/server';
import { getToken } from 'next-auth/jwt';

export async function middleware(req) {
  const token = await getToken({ req });
  const isAuth = !!token;

  const isAdminRoute = req.nextUrl.pathname.startsWith('/admin');
  const isTechnicianRoute = req.nextUrl.pathname.startsWith('/technician');
  const isDashboardRoute = req.nextUrl.pathname.startsWith('/dashboard');

  // Routes publiques (comme le scanner QR)
  const isPublicRoute = req.nextUrl.pathname.startsWith('/scan');

  if (!isAuth && (isAdminRoute || isTechnicianRoute || isDashboardRoute)) {
    return NextResponse.redirect(new URL('/login', req.url));
  }

  // Contrôle des accès basé sur le rôle
  if (isAuth) {
    const userRole = token.role;

    if (isAdminRoute && userRole !== 'ADMIN' && userRole !== 'SUPER_ADMIN') {
      return NextResponse.redirect(new URL('/unauthorized', req.url));
    }

    if (isTechnicianRoute && userRole !== 'TECHNICIAN' && userRole !== 'ADMIN' && userRole !== 'SUPER_ADMIN') {
      return NextResponse.redirect(new URL('/unauthorized', req.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/admin/:path*', '/technician/:path*', '/dashboard/:path*']
}