---
name: aiops-community-proposal
description: Draft a client proposal on behalf of an individual IT professional (freelancer, developer, engineer, consultant) responding to an assignment, klus, project, or vacancy found via the AiOps Community (the Dutch-language AI community for IT professionals, founded by Jeroen Veltenaar and Kain Ditmer). Use this skill whenever the user wants to write, draft, or "opstellen" a proposal, pitch, offerte, or reactie for an opportunity from the AiOps Community jobboard, Slack, or network, or more generally whenever an individual IT professional asks for a proposal to a prospective client in a plain, honest, non-salesy style, even if they don't name the community or this skill. Do not use for editing an existing proposal, for company-to-company sales decks, or for CVs and cover letters for permanent employment.
---

# AiOps Community proposal drafting

This skill drafts proposals on behalf of an individual IT professional responding to an opportunity that reached them via the AiOps Community: a Dutch-language network of developers, engineers, architects and consultants where professionals and clients deal with each other directly, without intermediaries. The proposal therefore comes from one named person, speaks in the first person singular, and goes straight to the client.

The writing style is calm, plain, and candid rather than polished or promissory. Confidence is reserved for what can be defended; everything speculative is hedged; assumptions are marked as assumptions; nothing exists purely to sound good. A community built on kennisdeling zonder commerciële ruis is the audience: any sentence that reads as sales copy is a sentence that damages trust.

Write the proposal in the language of the assignment text: a Dutch klus gets a Dutch proposal, an English request gets an English proposal. Two exceptions override this default: the assignment or the user explicitly names a required language (`reageren mag in het Engels`, `proposal in Dutch please`), or the user asks for a different language themselves. When the assignment mixes languages or the language is unclear, ask; the community itself is Dutch-language, so Dutch is the fallback. Headings, the community section, and the notes after drafting follow the language of the proposal.

## Before drafting: gather the facts

A proposal is only as honest as its inputs. Collect these from the conversation, and ask the user for whatever is missing rather than inventing it:

1. **The assignment**: what the client asked for, in their words if available.
2. **The professional**: name, role, and the experience that is actually relevant. Never fabricate or embellish experience; if the user gives none, write the experience section as a placeholder and say so.
3. **Practical terms**: availability, preferred start date, hourly rate or budget indication, remote/on-site, expected duration. Any of these the user has not supplied are left as marked open points, not guessed.
4. **The route**: how the opportunity arrived (jobboard, Slack, an introduction). One plain sentence of context at the start is enough; do not lean on the community as a credential.

If the essentials (assignment + at least a sketch of relevant experience) are missing, ask one focused round of questions before writing.

## Proposal structure

Use this structure, with sentence-case headings, adapted or trimmed where a section has nothing honest to say:

```
# Voorstel: [korte omschrijving van de opdracht]

## Aanleiding
## Wat ik begrijp van de opdracht
## Aanpak
## Wat ik oplever
## Relevante ervaring
## Over de AiOps Community
## Praktisch
## Volgende stap
```

- **Aanleiding**: one or two sentences. How the assignment reached the professional and why they are responding. No flattery of the client.
- **Wat ik begrijp van de opdracht**: restate the assignment in plain words. This is where hedging does its work: everything inferred from a short assignment text is marked `(ik neem aan)` or `naar verwachting`. Getting the client to correct a wrong assumption here is a feature, not a failure.
- **Aanpak**: how the work would be done, in undramatic steps. Proposed but unagreed elements use *zou* and *kan*, not the present tense.
- **Wat ik oplever**: only what is actually committed. No bonus assurances (`geen downtime`, `u hoeft niets te doen`) unless certain.
- **Relevante ervaring**: two to four factual sentences. Facts over adjectives: what was built, for whom, and what it did, not `ruime ervaring` or `bewezen trackrecord`.
- **Over de AiOps Community**: two or three sentences, see rule 5. What membership factually means for the client: the professional is screened, and has a network of engineers to draw on.
- **Praktisch**: availability, start, rate, location, duration. Unknown items appear as open points: `Tarief: in overleg` only if the user chose that; otherwise ask.
- **Volgende stap**: one sentence proposing a short call or a written reply. No urgency tricks, no `ik hoor graag snel van u`.

## House style

Every sentence of the proposal follows these:

- **Hedge what is not verified.** What is inferred or not yet agreed is marked as such: `(ik neem aan)`, `naar verwachting`, *zou* and *kan*.
- **No rhetoric or self-assurance.** Leave out sentences whose only job is to sound convincing: `ik ben ervan overtuigd dat`, `uiteraard`, `zonder twijfel`.
- **Plain vocabulary.** The ordinary word over the impressive one: `gebruiken`, not `inzetten` or `leveragen`.
- **No intensifiers.** `zeer`, `enorm`, `echt` and `absoluut` add nothing a fact does not.
- **No overreach.** Promise only what is in scope and certain.
- **Sentence case** in headings.
- **No em dashes.** Use a comma, a colon or a new sentence.

## The rules

The rules below cover what is specific to drafting from scratch on behalf of an individual.

### 1. First person singular, one named human
The proposal is from a person, not a brand. Use *ik*, never *wij*, and never invent a company voice around a freelancer.

Wrong: `Wij helpen organisaties bij het realiseren van AI-oplossingen`
Right: `Ik bouw en onderhoud AI-toepassingen voor MKB-bedrijven`

### 2. Mark every inference about the client as an inference
Assignment texts are short; most of what a proposal says about the client's situation is guessed. Say so, in line with the parenthetical style: `(ik neem aan)`, `naar verwachting`, `als ik het goed lees`.

Wrong: `Jullie data staat verspreid over meerdere systemen en is van wisselende kwaliteit`
Right: `Jullie data staat (ik neem aan) verspreid over meerdere systemen; de kwaliteit ervan is een van de eerste dingen die ik zou willen bekijken`

### 3. Named technology is allowed in experience, generic in the solution
For the professional's own past work, concrete names are facts and may stay (`een RAG-pijplijn in Python op Azure`). In the proposed approach, describe the class of technology, because naming a stack commits to an implementation before scoping.

Approach, wrong: `Ik zet dit op met LangChain, GPT-4o en Pinecone`
Approach, right: `Ik zet dit op met een taalmodel en een vectordatabase; welke precies volgt uit de eisen`

### 4. Experience claims must be defensible, and gaps stay visible
Write only experience the user has stated. Where the assignment asks for something the professional has not done, do not paper over it; name it plainly and, where true, pair it with the nearest real experience. In this community the client can verify claims through the network; an honest gap reads better than a discovered exaggeration.

Example: `Met [gevraagde technologie X] heb ik niet eerder gewerkt; wel met [verwant Y], waar dezelfde concepten in terugkomen.`

### 5. Name the community route, and include the community section
State the route in the aanleiding by default: `Ik zag deze opdracht op het jobboard van de AiOps Community` (or via Slack, or via an introduction, whichever is true). This is the preferred opening; only leave it out if the opportunity genuinely did not come via the community.

Include the short section `Over de AiOps Community` with a factual elevator pitch of two or three sentences. It tells the client two things that are true and relevant: members are screened (only IT professionals, no intermediaries), and the professional can draw on a network of engineers when the work calls for it. Keep it in house style: no superlatives, no member counts that go stale, no name-dropping of founders, and no suggestion that membership itself guarantees quality of work.

Example section:

```
## Over de AiOps Community
Ik ben lid van de AiOps Community, een Nederlandstalig netwerk van gescreende
IT-professionals rond toepasbare AI. Dat betekent voor jullie dat ik waar
nodig kan sparren met andere engineers uit dat netwerk, en dat er geen
bemiddelaar tussen ons in zit.
```

Adapt the wording to the proposal; do not paste it verbatim into every proposal so that clients who receive several proposals from members do not read the same paragraph twice.

### 6. Persuade through clarity
The proposal persuades, if it does, by being clear about the work and honest about the terms. That leaves no room for a sales apparatus: no unique selling points, no `waarom ik`, no closing paragraph that argues the case, no urgency, no exclamation marks.

### 7. Keep the door open without pitching
Where adjacent work exists that the professional could also do (beheer after delivery, training, integration), it may be offered in one plain sentence as an option, phrased as availability rather than a pitch.

Example: `Als na oplevering hulp bij beheer gewenst is, kan ik dat ook verzorgen.`

### 8. Short enough to be read
A response to a jobboard klus is one page or less. Reach that length by leaving sections out, not by compressing prose into dense blocks.

## After drafting

Give the proposal first, then a short note listing: (a) the assumptions marked in the text that the client should confirm, (b) the open points still needed from the user (rate, dates, experience details), and (c) any judgment call worth flagging, especially under rules 4 and 7. Offer to tighten further once the user fills the gaps.
