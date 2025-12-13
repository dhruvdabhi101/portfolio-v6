import Link from "next/link";
import { getAllPosts } from "@/lib/posts";

export default function Page() {
  const posts = getAllPosts();

  return (
    <div className="min-h-screen flex justify-center pt-24 pb-12 px-4">
      <div className="max-w-xl w-full space-y-8">
        {/* Header */}
        <div className="space-y-2">
          <h1 className="text-4xl font-bold">Dhruv Dabhi</h1>
          <p className="text-lg text-muted-foreground">Software Engineer</p>
        </div>

        {/* Intro Text */}
        <div className="space-y-4">
          <p className="text-foreground">
            I love software, some days i might be building Neovim plugins, or some days might be building web apps for
            clients and some days it might be desktop or cli apps.
          </p>
          <p className="text-foreground">I also sometimes vibe code apps which i never use.</p>
        </div>

        {/* Blog List */}
        <div className="space-y-4">
          <h2 className="text-2xl font-semibold">Blog</h2>
          {posts.length > 0 ? (
            <ul className="space-y-3">
              {posts.map((post) => (
                <li key={post.slug}>
                  <Link href={`/blog/${post.slug}`} className="text-foreground hover:text-primary transition-colors">
                    <div className="flex flex-col">
                      <span className="font-medium">{post.title}</span>
                      {post.date && (
                        <span className="text-sm text-muted-foreground">
                          {new Date(post.date).toLocaleDateString("en-US", {
                            year: "numeric",
                            month: "long",
                            day: "numeric",
                          })}
                        </span>
                      )}
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          ) : (
            <p className="text-muted-foreground">No blog posts yet.</p>
          )}
        </div>

        {/* Footer Text */}
        <div className="space-y-4 pt-8">
          <p className="text-foreground">
            Feel free to reach out to me on{" "}
            <Link
              href="https://x.com/dhruvdabhi101"
              target="_blank"
              className="text-primary hover:text-primary/80 transition-colors"
            >
              X
            </Link>{" "}
            or{" "}
            <Link
              href="https://github.com/dhruvdabhi101"
              target="_blank"
              className="text-primary hover:text-primary/80 transition-colors"
            >
              GitHub
            </Link>
            .
          </p>
        </div>
      </div>
    </div>
  );
}
