# AGENTS.md
# Comprehensive Guidelines for Agentic Coding Agents

## Overview
This document serves as a comprehensive guide for automated coding agents working in the CloudSoft web application repository. It includes:
- Build, test, and lint commands
- Code style conventions (naming, formatting, types)
- Architecture patterns and best practices
- Project-specific rules and workflows
- Troubleshooting guidance

All agentic tools should follow these guidelines when making changes to ensure consistency across the codebase.

---

## Project Structure
```
src/CloudSoft/
├── Controllers/      # MVC controllers
├── Models/           # Data models
├── Views/            # Razor views
├── wwwroot/          # Static assets
└── Program.cs        # Application entry point
```

---

## Build Commands

### Building the Project
```bash
cd src/CloudSoft
dotnet build
```

Build with release configuration:
```bash
dotnet build --configuration Release
```

Clean and rebuild:
```bash
dotnet clean && dotnet build
```

### Running the Application
```bash
cd src/CloudSoft
dotnet run --urls http://localhost:5000
```

Run in production mode:
```bash
dotnet run --configuration Release
```

---

## Testing

### Test Framework
The project uses xUnit for unit testing (if test projects exist).

### Running All Tests
```bash
cd src
dotnet test
```

Run tests with verbose output:
```bash
dotnet test -v n
```

Run specific test project:
```bash
dotnet test <TestProjectName>
```

### Running a Single Test
To run a single test method:
```bash
dotnet test --filter "FullyQualifiedName=Namespace.ClassName.MethodName"
```

Example:
```bash
dotnet test --filter "FullyQualifiedName=Tests.Controllers.HomeControllerTests.Index_Returns_View"
```

List available tests:
```bash
dotnet test --list-tests
```

---

## Code Style Guidelines

### C# Conventions

#### Naming Conventions
- **Classes**: PascalCase (`UserService`, `NewsletterController`)
- **Methods**: PascalCase (`GetUser()`, `Subscribe()`)
- **Variables**: camelCase (`userName`, `emailAddress`)
- **Private fields**: camelCase with underscore prefix (`_logger`, `_service`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `DEFAULT_TIMEOUT`)

#### Bracing and Indentation
- Opening braces on same line
- 4-space indentation
- Consistent brace placement

#### Using Directives
- Group using directives by namespace
- System namespaces first, then external libraries, then local project references
- Remove unused usings

#### Nullable Reference Types
Enabled via `<Nullable>enable</Nullable>` in .csproj. Always annotate nullability:
```csharp
public string Name { get; set; } // Non-nullable
public string Email { get; set; } = default!; // Explicitly nullable
```

#### String Literals
Use verbatim strings (`@"..."`) for file paths or multi-line content:
```csharp
string path = @"C:\Users\Public\Documents";
string sqlQuery = @"SELECT * FROM Users WHERE Active = 1";
```

Avoid magic strings; use constants or static readonly fields instead:
```csharp
private const string DefaultRole = "User";
// Instead of: if (role == "User")
if (role == DefaultRole)
```

### ASP.NET Core Specific Conventions

#### Controller Methods
- Use `[HttpGet]`, `[HttpPost]`, etc. attributes explicitly
- Separate GET and POST methods with different signatures or attributes
- Return appropriate IActionResult types

#### View Models
Create dedicated view models instead of passing entities directly to views:
```csharp
public class SubscribeViewModel
{
    public string? Name { get; set; }
    public string? Email { get; set; }
}
```

#### Error Handling
Use ProblemDetails for API errors:
```csharp
return BadRequest(new ProblemDetails
{
    Title = "Invalid model state",
    Detail = "Please provide valid data."
});
```

For MVC controllers, use ModelState validation:
```csharp
if (!ModelState.IsValid)
{
    return View(model);
}
```

#### Logging
Inject ILogger<T> and use structured logging:
```csharp
private readonly ILogger<NewsletterController> _logger;

_logger.LogInformation("Processing subscription for {Email}", email);
_logger.LogError(exception, "Error processing subscription");
```

---

## Architecture Patterns

### Layer Separation
- Controllers handle HTTP concerns only
- Business logic belongs in services
- Data access in repositories
- Views display data (minimal logic)

### Dependency Injection
All dependencies should be injected via constructor injection:
```csharp
public class NewsletterService
{
    private readonly IEmailSender _emailSender;
    
    public NewsletterService(IEmailSender emailSender)
    {
        _emailSender = emailSender;
    }
}
```

Register services in Program.cs:
```csharp
builder.Services.AddScoped<IUserRepository, UserRepository>();
```

---

## Best Practices

### Validation
Always validate input:
- Use DataAnnotations on view models
- Perform additional validation in service layer
- Provide clear error messages

### Security
- Never trust user input
- Sanitize outputs to prevent XSS
- Use Anti-Forgery tokens for forms
- Implement proper authentication/authorization

### Performance
- Avoid N+1 query problems
- Use async/await for I/O operations
- Cache frequently accessed data when appropriate
- Minimize view complexity

### Testing Guidelines
- Test one behavior per test method
- Use descriptive test names
- Mock external dependencies
- Test both happy paths and edge cases
- Include tests for error conditions

### Code Organization
- Group related methods together logically
- Keep classes focused on single responsibilities
- Limit class size to ~200 lines when possible
- Use regions sparingly, prefer clear method organization

---

## Project-Specific Rules

### File Organization
- Place related files in the same directory
- Follow convention over configuration
- Keep controllers thin (delegate to services)

### Documentation
- Add XML comments for public APIs
- Document complex algorithms
- Update documentation when code changes

### Git Commit Messages
Follow conventional commits format:
- `feat: add new feature`
- `fix: resolve bug`
- `docs: update documentation`
- `style: formatting changes`
- `refactor: improve code structure`
- `test: add tests`

---

## Agent-Specific Instructions

### When Making Changes
1. Always read existing code first
2. Follow established patterns
3. Maintain consistency with surrounding code
4. Run build after making changes
5. Verify no regressions introduced

### Before Submitting Work
1. Check for unused usings
2. Ensure proper nullability annotations
3. Validate naming conventions
4. Confirm error handling is present
5. Review logging statements
6. Test manually if possible

### Common Tasks
To create a new controller:
1. Create file in Controllers/
2. Add corresponding View folder
3. Create basic Index action
4. Add to navigation if applicable

To add a new model:
1. Create class in Models/
2. Add DataAnnotations for validation
3. Create view model if needed
4. Write repository/service methods

---

## Troubleshooting

### Build Failures
Check for:
- Missing dependencies
- Compilation errors
- Configuration issues
- Version mismatches

### Runtime Errors
Use:
```bash
dotnet run --environment Development
```

Check logs in:
- Console output
- Log files in working directory
- Browser developer tools

### Database Issues
If using Entity Framework:
```bash
dotnet ef migrations add <Name>
dotnet ef database update
```

---

## Additional Resources
- [ASP.NET Core Documentation](https://learn.microsoft.com/en-us/aspnet/core/)
- [C# Coding Conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- [xUnit Documentation](https://xunit.net/)
