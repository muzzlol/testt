import { type FormEvent, useRef, useState } from "react";

export function APITester() {
	const responseInputRef = useRef<HTMLTextAreaElement>(null);
	const [loading, setLoading] = useState(false);
	const [errorMsg, setErrorMsg] = useState<string | null>(null);

	const testEndpoint = async (e: FormEvent<HTMLFormElement>) => {
		e.preventDefault();
		setErrorMsg(null);
		setLoading(true);
		if (responseInputRef.current) {
			responseInputRef.current.value = "";
		}

		try {
			const form = e.currentTarget;
			const formData = new FormData(form);
			const endpoint = (formData.get("endpoint") as string)?.trim();
			const method = (formData.get("method") as string) || "GET";

			if (!endpoint) {
				setErrorMsg("Endpoint URL cannot be empty.");
				setLoading(false);
				return;
			}

			let url: URL;
			try {
				url = endpoint.startsWith("http")
					? new URL(endpoint)
					: new URL(endpoint, location.origin);
			} catch {
				setErrorMsg("Invalid URL.");
				setLoading(false);
				return;
			}

			const res = await fetch(url.toString(), { method });

			let responseText: string;
			const contentType = res.headers.get("content-type") || "";
			if (!res.ok) {
				responseText = `Error ${res.status}: ${res.statusText}`;
				try {
					if (contentType.includes("application/json")) {
						const errorData = await res.json();
						responseText += "\n" + JSON.stringify(errorData, null, 2);
					} else {
						responseText += "\n" + (await res.text());
					}
				} catch {}
				if (responseInputRef.current)
					responseInputRef.current.value = responseText;
				setLoading(false);
				return;
			}

			if (contentType.includes("application/json")) {
				const data = await res.json();
				responseText = JSON.stringify(data, null, 2);
			} else {
				responseText = await res.text();
			}

			if (responseInputRef.current)
				responseInputRef.current.value = responseText;
		} catch (error) {
			setErrorMsg(String(error));
			if (responseInputRef.current) responseInputRef.current.value = "";
		} finally {
			setLoading(false);
		}
	};

	return (
		<div className="api-tester">
			<form onSubmit={testEndpoint} className="endpoint-row">
				<select name="method" className="method" disabled={loading}>
					<option value="GET">GET</option>
					<option value="PUT">PUT</option>
					<option value="POST">POST</option>
					<option value="DELETE">DELETE</option>
					<option value="PATCH">PATCH</option>
				</select>
				<input
					type="text"
					name="endpoint"
					defaultValue="/api/hello"
					className="url-input"
					placeholder="/api/hello or https://example.com/api"
					disabled={loading}
					autoComplete="off"
				/>
				<button type="submit" className="send-button" disabled={loading}>
					{loading ? "Sending..." : "Send"}
				</button>
			</form>
			{errorMsg && (
				<div style={{ color: "red", marginTop: "0.25em", fontSize: "0.95em" }}>
					{errorMsg}
				</div>
			)}
			<textarea
				ref={responseInputRef}
				readOnly
				placeholder="Response will appear here..."
				className="response-area"
				rows={12}
				style={{ marginTop: "0.5em", width: "100%", resize: "vertical" }}
			/>
		</div>
	);
}
