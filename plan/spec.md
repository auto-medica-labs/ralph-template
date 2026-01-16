# Mock ERP HTTP server for inventory management

This project purpose is to provide mock http endpoint for testing inventory management functionality.

The server will exposes 3 HTTP endpoint

1. GET `/inventory`: will return json response with http 200 status with this schema

```ts
export type ERPInventoryResponse = {
  sku: string;
  locationCode: string;
  availableQty: number;
  totalQty: number;
  lot: {
    lotNumber: string;
    /**
     * @description unix epoch (millisec 13 digit)
     */
    expDate: number;
    availableQty: number;
    totalQty: number;
  };
};
```

2. POST `/reserve`: will return nothing but http status 200 (good) and 400 (bad) which can configured in the code with boolean, this endpoint will accept request body like

```json
{
  "reserveId": "<uuid>",
  "items": [
    {
      "sku": "<sku>",
      "quantity": 9
    },
    {
      "sku": "<sku>",
      "quantity": 11
    }
  ]
}
```

3. POST `/release`: will return nothing but http status 200 (good) and 400 (bad) which can configured in the code with boolean, this endpoint will accept request body like

```json
{
  "reservedId": "<uuid>"
}
```

This project will use Bun as a runtime and will be built using typescript, refer reference for Bun native HTTP server at [link](https://bun.com/docs/runtime/http/server).

Here the example to get you start.

```ts
const server = Bun.serve({
  // `routes` requires Bun v1.2.3+
  routes: {
    // Static routes
    "/api/status": new Response("OK"),

    // Dynamic routes
    "/users/:id": req => {
      return new Response(`Hello User ${req.params.id}!`);
    },

    // Per-HTTP method handlers
    "/api/posts": {
      GET: () => new Response("List posts"),
      POST: async req => {
        const body = await req.json();
        return Response.json({ created: true, ...body });
      },
    },

    // Wildcard route for all routes that start with "/api/" and aren't otherwise matched
    "/api/*": Response.json({ message: "Not found" }, { status: 404 }),

    // Redirect from /blog/hello to /blog/hello/world
    "/blog/hello": Response.redirect("/blog/hello/world"),

    // Serve a file by lazily loading it into memory
    "/favicon.ico": Bun.file("./favicon.ico"),
  },

  // (optional) fallback for unmatched routes:
  // Required if Bun's version < 1.2.3
  fetch(req) {
    return new Response("Not Found", { status: 404 });
  },
});

console.log(`Server running at ${server.url}`);
```
