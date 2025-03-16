import NextAuth from 'next-auth/next';
import CredentialsProvider from 'next-auth/providers/credentials';

const handler = NextAuth({
  providers: [
      CredentialsProvider({
        name: 'AirSafeAuth',
        credentials: {
          email: { label: "E-mail", type: 'text', placeholder: 'Votre Email' },
          password: { label: "Password", type: 'password', placeholder: 'Votre mot de passe' },
        },
        async authorize(credentials, res) {
          const response = await fetch('http://localhost:3000/api/login', {
            method: 'POST',
            body: JSON.stringify({
              email: credentials?.email,
              password: credentials?.password,
            }),
          });
          const user = await response.json();

          return user || null;
        }
      })
  ]
});

export { handler as GET, handler as POST };