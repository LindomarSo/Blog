using Blog.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Blog.Mappings
{
    public class UserMap : IEntityTypeConfiguration<User>
    {
        public void Configure(EntityTypeBuilder<User> builder)
        {
            // Table
            builder.ToTable("User");

            // Primary Key
            builder.HasKey(x => x.Id);

            // Identity
            builder.Property(x => x.Id)
                   .ValueGeneratedOnAdd()
                   .UseIdentityColumn(); // Auto Increment

            // Properties 
            builder.Property(x => x.Name)
                    .IsRequired() // Not null
                    .HasColumnName("Name") // Column name
                    .HasColumnType("NVARCHAR") // Type
                    .HasMaxLength(100); // Field Size

            // TODO: Refactor
            builder.Property(x => x.Bio)
                    .HasColumnType("VARCHAR")
                    .HasMaxLength(250);

            builder.Property(x => x.Email)
                    .IsRequired()
                    .HasColumnType("VARCHAR")
                    .HasMaxLength(250);

            builder.Property(x => x.Image);
            builder.Property(x => x.GitHub);
            builder.Property(x => x.PasswordHash);

            builder.Property(x => x.Slug)
                    .IsRequired() // Not null
                    .HasColumnName("Slug") // Column name
                    .HasColumnType("VARCHAR") // Type
                    .HasMaxLength(100); // Field Size

            // Index
            builder.HasIndex(x => x.Slug, "IX_User_Slug")
                    .IsUnique(); // Allows only values uniques


            // Relationships many to many
            builder.HasMany(x => x.Roles)
                   .WithMany(x => x.Users)
                   .UsingEntity<Dictionary<string, object>>(
                    "UserRole", // Table name
                    role => role.HasOne<Role>()
                                .WithMany()
                                .HasForeignKey("RoleId")
                                .HasConstraintName("FK_UserRole_RoleId")
                                .OnDelete(DeleteBehavior.Cascade),
                    user => user.HasOne<User>()
                                .WithMany() 
                                .HasForeignKey("UserId")
                                .HasConstraintName("FK_UserRole_UserId")
                                .OnDelete(DeleteBehavior.Cascade)
                );
        }
    }
}
