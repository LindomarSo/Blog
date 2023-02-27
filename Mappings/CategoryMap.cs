using Blog.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Blog.Mappings
{
    public class CategoryMap : IEntityTypeConfiguration<Category>
    {
        public void Configure(EntityTypeBuilder<Category> builder)
        {
            // Table
            builder.ToTable("Category", "dbo");

            // Primary Key
            builder.HasKey(x => x.Id);

            // Identity
            builder.Property(x => x.Id)
                   .ValueGeneratedOnAdd()
                   .UseIdentityColumn(); // Primary Key Identity(1,1)

            // Properties 
            builder.Property(x => x.Name)
                    .IsRequired() // Not null
                    .HasColumnName("Name") // Column name
                    .HasColumnType("NVARCHAR") // Type
                    .HasMaxLength(100); // Field Size

            builder.Property(x => x.Slug)
                    .IsRequired() // Not null
                    .HasColumnName("Slug") // Column name
                    .HasColumnType("VARCHAR") // Type
                    .HasMaxLength(100); // Field Size

            // Index
            builder.HasIndex(x => x.Slug, "IX_Category_Slug")
                    .IsUnique(); // Allows only values uniques
        }
    }
}
