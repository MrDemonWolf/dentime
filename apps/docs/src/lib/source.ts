import { loader } from "fumadocs-core/source";
import { docs } from "@/.source/server.ts";

const raw = docs.toFumadocsSource();
const files =
	typeof raw.files === "function"
		? (raw.files as unknown as () => typeof raw.files)()
		: raw.files;

export const source = loader({
	baseUrl: "/docs",
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	source: { ...raw, files } as any,
});
