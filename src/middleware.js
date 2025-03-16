import { withAuth } from 'next-auth/middleware';

export function middleware(request) {
  if(request.nextUrl.pathname.startsWith('/profile') ) {
    return withAuth(request)
  }

}

export const config = {
  matcher: "/((?!api|_next/static|_next/image|favicon.ico).*)",
}