
class MyApp
  before do
    csp = [
      "base-uri 'self'",
      "connect-src 'self'",
      "default-src 'self'",
      "font-src 'self' https://fonts.gstatic.com",
      "form-action 'self'",
      "frame-ancestors 'self'",
      "img-src 'self'",
      "object-src 'none'",
      "script-src 'self' 'nonce-#{session[:nonce]}'",
      "style-src 'self' 'nonce-#{session[:nonce]}' https://fonts.googleapis.com"
    ].join("; ")

    headers 'Content-Security-Policy' => csp
  end
end
