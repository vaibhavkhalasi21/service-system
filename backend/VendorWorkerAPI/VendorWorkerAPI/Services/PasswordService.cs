using Microsoft.AspNetCore.Identity;

namespace VendorWorkerAPI.Services
{
    public static class PasswordService
    {
        private static readonly PasswordHasher<string> _hasher = new();

        public static string Hash(string password)
        {
            return _hasher.HashPassword(null, password);
        }

        public static bool Verify(string password, string hash)
        {
            return _hasher.VerifyHashedPassword(null, hash, password)
                   == PasswordVerificationResult.Success;
        }
    }
}
