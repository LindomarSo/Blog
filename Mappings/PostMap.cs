using Blog.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Blog.Mappings
{
    public class PostMap : IEntityTypeConfiguration<Post>
    {
        public void Configure(EntityTypeBuilder<Post> builder)
        {
            // Table
            builder.ToTable(nameof(Post));

            // Primary key
            builder.HasKey(x => x.Id);

            // Auto Increment
            builder.Property(x => x.Id)
                   .ValueGeneratedOnAdd()
                   .UseIdentityColumn();

            // Properties
            builder.Property(x => x.LastUpdateDate)
                    .IsRequired() // Not null
                    .HasColumnName("LastUpdateDate") // Column name
                    .HasColumnType("SMALLDATETIME") // Type
                    .HasDefaultValueSql("GETDATE()");

            // Index
            builder.HasIndex(x => x.Slug, "IX_Post_Slup")
                   .IsUnique();

            // Relationships One To Many
            builder.HasOne(x => x.Author)
                .WithMany(x => x.Posts)
                .HasConstraintName("FK_Post_Author")
                .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(x => x.Category)
                .WithMany(x => x.Posts)
                .HasConstraintName("FK_Post_Category")
                .OnDelete(DeleteBehavior.NoAction);

            // Relationships many to many
            builder.HasMany(x => x.Tags)
                   .WithMany(x => x.Posts)
                   .UsingEntity<Dictionary<string, object>>( // Entidade Virtual 
                    "PostTag",
                    post => post.HasOne<Tag>()
                                .WithMany()
                                .HasForeignKey("PostId") 
                                .HasConstraintName("FK_PostTag_PostId")
                                .OnDelete(DeleteBehavior.Cascade),
                    tag => tag.HasOne<Post>()
                               .WithMany()
                               .HasForeignKey("TagId")
                               .HasConstraintName("FK_PostTag_TagId")
                               .OnDelete(DeleteBehavior.Cascade));
        }  
    }
}
