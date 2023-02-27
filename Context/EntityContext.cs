using Blog.Mappings;
using Blog.Models;
using Microsoft.EntityFrameworkCore;

namespace Blog.Context
{
    public class EntityContext : DbContext
    {
        public DbSet<Category> Category { get; set; }
        public DbSet<Post> Post { get; set; }
        public DbSet<User> User { get; set; }
        public DbSet<PostWithTagsCount> PostWithTagsCount { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) =>
            optionsBuilder.UseSqlServer("Server=localhost,1433;Database=FluentBlog;User ID=sa;Password=1q2w3e4r@#$;TrustServerCertificate=true;");

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new CategoryMap());
            modelBuilder.ApplyConfiguration(new PostMap());
            modelBuilder.ApplyConfiguration(new UserMap());

            modelBuilder.Entity<PostWithTagsCount>(x =>
            {
                x.ToSqlQuery(@"
                    SELECT
                        [Title] AS Name,
                        (SELECT COUNT(Id)
                        FROM PostTag pt INNER JOIN Tag t ON pt.TagId = t.Id
                        WHERE PostId = Id) AS Count
                    FROM Post");
            });
        }
    }
}
