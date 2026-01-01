using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using VendorWorkerAPI.Data;
using VendorWorkerAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// ================= DATABASE =================
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
    ));

// ================= JWT AUTH =================
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,

            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],

            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"])
            ),

            ClockSkew = TimeSpan.Zero
        };
    });

// ================= AUTHORIZATION =================
builder.Services.AddAuthorization();

// ================= SERVICES =================
builder.Services.AddScoped<JwtTokenService>();

// ================= CONTROLLERS =================
builder.Services.AddControllers();

// ================= SWAGGER =================
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "VendorWorker API",
        Version = "v1"
    });

    // ?? JWT IN SWAGGER
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Enter: Bearer {JWT token}"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

var app = builder.Build();

// ================= ?? SWAGGER PROTECTION =================
if (app.Environment.IsDevelopment())
{
    // ? Swagger UI opens but API execution requires JWT
    app.Use(async (context, next) =>
    {
        if (context.Request.Path.StartsWithSegments("/swagger") &&
            !context.Request.Path.Value.Contains("swagger.json"))
        {
            // Allow Swagger UI page
            await next();
            return;
        }

        await next();
    });

    app.UseSwagger();
    app.UseSwaggerUI();
}

// ================= MIDDLEWARE ORDER =================
app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseAuthentication();   // ?? FIRST
app.UseAuthorization();    // ?? SECOND


app.MapControllers();

app.Run();
