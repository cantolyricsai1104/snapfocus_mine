import React, { useState } from 'react';
import type { SupabaseClient } from '@supabase/supabase-js';

export const AuthScreen: React.FC<{ client: SupabaseClient }> = ({ client }) => {
  const [mode, setMode] = useState<'signin' | 'signup'>('signin');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    setBusy(true);
    setMessage('');
    setError('');
    try {
      if (mode === 'signup') {
        const { data, error: authError } = await client.auth.signUp({
          email: email.trim(),
          password,
        });
        if (authError) throw authError;
        if (!data.session) setMessage('Check your email to confirm your account, then sign in.');
      } else {
        const { error: authError } = await client.auth.signInWithPassword({
          email: email.trim(),
          password,
        });
        if (authError) throw authError;
      }
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : 'Could not connect. Please try again.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <main className="min-h-screen bg-[#0E0E11] text-white flex items-center justify-center p-5">
      <form onSubmit={submit} className="w-full max-w-sm rounded-3xl border border-white/10 bg-[#17171C] p-6 shadow-2xl">
        <div className="text-center mb-6">
          <div className="mx-auto mb-3 grid h-14 w-14 place-items-center rounded-2xl bg-[#FF6B00]/15 text-2xl">🌱</div>
          <h1 className="text-2xl font-black">SnapFocus</h1>
          <p className="mt-1 text-sm text-neutral-400">{mode === 'signin' ? 'Welcome back' : 'Create your account'}</p>
        </div>
        <label className="mb-3 block text-sm text-neutral-300">Email
          <input required type="email" autoComplete="email" value={email} onChange={(event) => setEmail(event.target.value)} className="mt-1.5 w-full rounded-xl border border-white/10 bg-black/20 px-3 py-3 text-white outline-none focus:border-[#FF6B00]" />
        </label>
        <label className="mb-4 block text-sm text-neutral-300">Password
          <input required minLength={8} type="password" autoComplete={mode === 'signin' ? 'current-password' : 'new-password'} value={password} onChange={(event) => setPassword(event.target.value)} className="mt-1.5 w-full rounded-xl border border-white/10 bg-black/20 px-3 py-3 text-white outline-none focus:border-[#FF6B00]" />
        </label>
        {error && <p role="alert" className="mb-3 rounded-xl bg-red-500/10 p-3 text-sm text-red-300">{error}</p>}
        {message && <p role="status" className="mb-3 rounded-xl bg-emerald-500/10 p-3 text-sm text-emerald-300">{message}</p>}
        <button disabled={busy} className="w-full rounded-xl bg-[#FF6B00] py-3 font-bold text-white disabled:opacity-60">
          {busy ? 'Please wait…' : mode === 'signin' ? 'Sign in' : 'Create account'}
        </button>
        <button type="button" onClick={() => { setMode(mode === 'signin' ? 'signup' : 'signin'); setError(''); setMessage(''); }} className="mt-3 w-full py-2 text-sm text-neutral-300 hover:text-white">
          {mode === 'signin' ? 'New to SnapFocus? Create an account' : 'Already have an account? Sign in'}
        </button>
        {mode === 'signin' && <button type="button" onClick={async () => {
          setError(''); setMessage('');
          if (!email.trim()) { setError('Enter your email first.'); return; }
          const { error: resetError } = await client.auth.resetPasswordForEmail(email.trim());
          if (resetError) setError(resetError.message); else setMessage('If the account exists, a reset email is on its way.');
        }} className="w-full py-1 text-sm text-neutral-500 hover:text-neutral-300">Forgot password?</button>}
      </form>
    </main>
  );
};
