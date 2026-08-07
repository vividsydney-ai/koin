import { createTransport, type Transporter } from "nodemailer";

export interface EmailMessage {
  to: string;
  subject: string;
  text: string;
  html?: string;
}

let transporter: Transporter | null = null;

function getTransporter(): Transporter {
  if (!transporter) {
    const host = process.env.SMTP_HOST;
    const port = process.env.SMTP_PORT ? Number(process.env.SMTP_PORT) : 587;
    const user = process.env.SMTP_USER;
    const pass = process.env.SMTP_PASS;

    if (!host || !user || !pass) {
      throw new Error("Missing SMTP configuration (SMTP_HOST, SMTP_USER, SMTP_PASS)");
    }

    transporter = createTransport({
      host,
      port,
      secure: port === 465,
      auth: { user, pass },
    });
  }
  return transporter;
}

export async function sendEmail(message: EmailMessage): Promise<void> {
  const from = process.env.SMTP_FROM ?? "hello@koinaku.com";
  const transport = getTransporter();

  const result = await transport.sendMail({
    from,
    to: message.to,
    subject: message.subject,
    text: message.text,
    html: message.html,
  });

  if (result.rejected.length > 0) {
    throw new Error(`Email rejected for ${result.rejected.join(", ")}`);
  }
}
