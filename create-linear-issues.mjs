import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });

const LINEAR_API_KEY = process.env.LINEAR_API_KEY;

const query = async (q) => {
  const res = await fetch('https://api.linear.app/graphql', {
    method: 'POST',
    headers: {
      'Authorization': LINEAR_API_KEY,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query: q }),
  });
  return res.json();
};

async function createLinearIssues() {
  try {
    // Create parent issue
    const parentDescription = `Created 13 new lessons to fill curriculum gaps, organized by priority:

**High Priority (5 lessons):**
- #53: ETFs: Investing with One Click (Chapter 07)
- #54: Banking Basics: Choosing the Right Account (Chapter 02)
- #55: Digital Wallets & QRIS: Safe and Smart Usage (Chapter 02)
- #56: Bonds & SBN: Safe Investing with the Government (Chapter 07)
- #57: Tax Basics: NPWP, PPh 21, and Filing Taxes (Chapter 05)

**Medium Priority (4 lessons):**
- #58: Net Worth: Know Your Financial Position (Chapter 01)
- #59: Insurance Basics: BPJS vs Private Insurance (Chapter 03)
- #60: Retirement Planning: BPJS, DPLK, and Starting Early (Chapter 05)
- #61: Brokerage Account Setup: Opening Your RDN (Chapter 07)

**Lower Priority (4 lessons):**
- #62: Sharia Investments: Reksa Dana Syariah and Sukuk (Chapter 06)
- #63: Gold Investment: Safe Haven in Turbulent Times (Chapter 06)
- #64: Stock Analysis Basics: Fundamental vs Technical (Chapter 07)
- #65: Debt Consolidation: When and How to Combine Debts (Chapter 04)

**Status:**
- All 13 lessons created in database
- 8 new topics created (ETF, Banking Basics, Digital Wallets, Bonds, Insurance, Retirement, Sharia, Gold)
- Pending review and publishing
- Need to add sources and content variants

**Next Steps:**
1. Review content for accuracy
2. Add Tier 1 sources
3. Create example and question variants
4. Publish lessons`;

    const parentResult = await query(`
      mutation {
        issueCreate(
          input: {
            teamId: "KO"
            title: "[KO-CURR-005] Curriculum Expansion: 13 New Lessons (High to Low Priority)"
            description: ${JSON.stringify(parentDescription)}
            priority: 2
            stateId: "KO-156"
          }
        ) {
          success
          issue {
            id
            identifier
            title
          }
        }
      }
    `);

    if (parentResult.data?.issueCreate?.success) {
      const parentIssue = parentResult.data.issueCreate.issue;
      console.log('✅ Created parent issue:', parentIssue.identifier);

      // Create child issues for each priority level
      const priorities = [
        { label: 'High Priority (5 lessons)', lessons: ['ETFs', 'Banking Basics', 'Digital Wallets & QRIS', 'Bonds & SBN', 'Tax Basics'] },
        { label: 'Medium Priority (4 lessons)', lessons: ['Net Worth', 'Insurance Basics', 'Retirement Planning', 'Brokerage Account Setup'] },
        { label: 'Lower Priority (4 lessons)', lessons: ['Sharia Investments', 'Gold Investment', 'Stock Analysis Basics', 'Debt Consolidation'] }
      ];

      for (const priority of priorities) {
        const childDescription = `Review and publish the following lessons:\n\n${priority.lessons.map(l => '- ' + l).join('\n')}\n\nTasks:\n- Review content accuracy\n- Add Tier 1 sources\n- Create variants\n- Publish`;

        const childResult = await query(`
          mutation {
            issueCreate(
              input: {
                teamId: "KO"
                parentId: "${parentIssue.id}"
                title: "[KO-CURR-005] ${priority.label}: Review and Publish"
                description: ${JSON.stringify(childDescription)}
                priority: 2
                stateId: "KO-156"
              }
            ) {
              success
              issue {
                id
                identifier
                title
              }
            }
          }
        `);

        if (childResult.data?.issueCreate?.success) {
          console.log('✅ Created child issue:', childResult.data.issueCreate.issue.identifier);
        } else {
          console.log('⚠️  Failed to create child issue for:', priority.label);
          console.log('Error:', JSON.stringify(childResult.errors || childResult, null, 2));
        }
      }

      console.log('\n✅ All Linear issues created successfully!');
    } else {
      console.error('❌ Failed to create parent issue:', JSON.stringify(parentResult, null, 2));
    }
  } catch (error) {
    console.error('❌ Error creating Linear issues:', error.message);
    console.error(error);
  }
}

createLinearIssues();
